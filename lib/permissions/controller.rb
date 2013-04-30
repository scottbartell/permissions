module Permissions
  module Controller

    extend ActiveSupport::Concern

    included do
      helper_method :can?
      helper_method :cannot?
    end


    module ClassMethods
      def permit_controller!
        before_filter :permit_controller!
      end
    end



    def deny!(msg=nil)
      msg ||= @authorization.message
      flash[:notice] = msg
      puts "AUTHORIZATION DENIED. @authorization output:"
      puts "\trule:        '#{@authorization.rule}'"
      puts "\tmessage:     '#{@authorization.message}'"
      puts "\tredirect_to: '#{@authorization.redirect_to}'"
      redirect_to @authorization.redirect_to
    end

    def permit_controller!
      deny! if cannot? controller_name, action_name
    end



    def cannot?(target, action)
      not can?(target, action)
    end

    def can?(target, action)
      authorization = Authorization.get
      authorization.reload_permissions!

      controller = self
      as_a = controller.instance_eval(&authorization.current_user_role)

      keys =  case target
                when *[String, Symbol]
                  [:controllers, target.to_sym]
                when ActiveRecord::Base
                  [:models, target.class.table_name.to_sym]
                when Class
                  [:models, target.table_name.to_sym]
                else raise "unknown target class #{target.class.name}"
              end

      area  = keys.first
      gname = keys.last



      # parsing and finding the correct rule

      ideal_path = [as_a, area, gname, action]
      actual_path = []

      rule = authorization.rules

      while rule.is_a? Hash
        hash = rule
        if ideal_path.any?
          last = ideal_path.shift.to_sym
          actual_path << last
          rule = hash[last] || false
        end
      end

      # evaluating the block with the controller

      if rule.is_a? Authorization::BlockHolder
        rule = controller.instance_eval(&rule.block)
      end

      # if no rule was found, assume default message and redirection

      rule = {} if !rule
      if rule.is_a? Hash
        rule[:message]     ||= controller.instance_eval(&authorization.denied_message)
        rule[:redirect_to] ||= controller.instance_eval(&authorization.denied_path)
      end
      # if !rule
      #   rule = {
      #     message: controller.instance_eval(&authorization.denied_message),
      #     redirect_to: controller.instance_eval(&authorization.denied_path)
      #   }
      # end

      rule_path = "/#{actual_path.join('/')}"

      result = case rule
                when TrueClass
                  Authorization::Result.new(rule_path, true)
                when Hash
                  Authorization::Result.new(rule_path, false, rule[:redirect_to], rule[:message])
                else
                  raise "unknown result -> #{rule.class.name}"
              end
      @authorization = result
      @authorization.b_granted
    end

  end
end