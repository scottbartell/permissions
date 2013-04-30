module Permissions
  class Authorization

    attr_reader :rules, :denied_path, :denied_message, :current_user_role

    def initialize
      @rules = {}
      #
      @c_role = nil
      @c_group = nil
      @c_element = nil
    end




    def reload_permissions!
      if File.exists? 'config/permissions.rb'
        load 'config/permissions.rb'
      else
        `rails g permissions:setup`
        reload_permissions!
      end
    end

    def draw(&block)
      @rules.clear
      set_default_blocks
      #clear! unless @disable_clear_and_finalize
      instance_eval(&block)
      #finalize! unless @disable_clear_and_finalize
      puts "PERMISSIONS! hey go write some rules in your config/permissions.rb".yellow if @rules.empty?
      nil
    end




    def set_default_blocks
      set_denied_path    { root_path }
      set_denied_message { "Access Denied to #{controller_name}##{action_name}" }
      set_current_user_role do
        current_user ? :user : :guest
      end
    end

    def set_denied_path(&block)
      @denied_path = block
    end

    def set_denied_message(&block)
      @denied_message = block
    end

    def set_current_user_role(&block)
      @current_user_role = block
    end

    class << self

      def get
        #Rails.env.development? ? new : (@instance ||= new)
        @instance ||= new
      end

    end



    def append(result, *trail, &block)
      rule = @rules
      last = trail.pop
      trail.each do |node|
        rule = rule[node] ||= {}
      end
      rule[last] = block_given? ? BlockHolder.new(block) : result
    end

    def role(*names, &block)
      raise "You cannot call role inside a controller or resource." if @c_group
      names.each do |name|
        @c_role = name
        @c_group = nil
        @c_element = nil
        instance_eval(&block)
        @c_role = nil
      end
    end

    def controller(*names, &block)
      names.each do |name|
        element(:controllers, name, &block)
      end
    end

    def model(*names, &block)
      names.each do |name|
        element(:models, name, &block)
      end
    end



    def element(group_name, element_name, &block)
      raise "Controller or resource can only be called directly inside a role." if @c_role.nil?
      @c_group = group_name
      @c_element = element_name
      instance_eval(&block)
      @c_group = nil
      @c_element = nil
    end

    def can(*names, &block)
      names.each do |name|
        append(true, @c_role, @c_group, @c_element, name, &block)
      end
    end

    def can_role(*names, &block)
      names.each do |name|
        append(true, name, &block)
      end
    end

    def can_controller(*names, &block)
      names.each do |name|
        append(true, @c_role, :controllers, name, &block)
      end
    end

    def can_model(*names, &block)
      names.each do |name|
        append(true, @c_role, :models, name, &block)
      end
    end








    class BlockHolder
      attr_reader :block
      def initialize(block)
        @block=block
      end
    end

    class Result
      attr_reader :message, :redirect_to, :rule, :b_granted
      def initialize(rule, b_granted, redirect_to=nil, message=nil)
        @rule         = rule
        @b_granted    = b_granted
        @redirect_to  = redirect_to
        @message      = message
      end
    end

  end
end