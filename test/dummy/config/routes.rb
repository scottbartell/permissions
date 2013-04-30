Rails.application.routes.draw do

  mount Permissions::Engine => "/permissions"
end
