module Permissions
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_ability
        copy_file "config.rb", "config/permissions.rb"
      end
    end
  end
end