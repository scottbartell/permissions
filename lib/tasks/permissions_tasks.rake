#desc 'Print out all defined permissions in match order, with names. Target specific role with ROLE=x.'
desc 'Print out all defined permissions grouped by role.'
task :permissions => :environment do
  # Rails.application.reload_routes!
  # all_routes = Rails.application.routes.routes

  # require 'rails/application/route_inspector'
  # inspector = Rails::Application::RouteInspector.new
  # puts inspector.format(all_routes, ENV['CONTROLLER']).join "\n"
  a = Permissions::Authorization.get
  a.reload_permissions!
  all_permissions = a.rules

  puts "+------------------------------------------------------+"
  puts "| PERMISSIONS "
  puts ""
  put_permission_internals all_permissions
  puts "+------------------------------------------------------+"
end

desc 'Alias for permissions'
task :perm => :permissions

def put_permission_internals(node, trail=[])
  node.each do |key, value|
    new_trail = trail+[key]
    full_key = "/#{new_trail.join('/')}"

    if value.is_a? Hash
      spaces = 4-new_trail.size
      puts "#{'*' * spaces} #{' ' * new_trail.size} #{new_trail.last.upcase}:".red
      put_permission_internals value, new_trail
      puts ''
    elsif value.is_a? Permissions::Authorization::BlockHolder
      puts "#{full_key} =\t{ block with controller scope }".green
    else
      puts "#{full_key} =\t#{value}".yellow
    end

  end
end