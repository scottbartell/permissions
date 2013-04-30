class Rails::Application
  def permissions
    Permissions::Authorization.get
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Permissions::Controller
  end
end