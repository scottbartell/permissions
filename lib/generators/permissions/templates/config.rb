Rails.application.permissions.draw do



  role :guest do

    # model :posts do
    #   can :index, :show
    # end

  end



  role :user do

    # model :posts do
    #   can :index, :show, :new, :create
    #   can :edit, :update, :destroy do
    #     current_user == @post.user
    #   end
    # end

  end



  set_denied_path    { root_path }

  set_denied_message { "Access Denied to #{controller_name}##{action_name}" }

  set_current_user_role do
    if current_user
      :user
    else
      :guest
    end
  end

  # Learn more
  # https://github.com/yakko/permissions

  # The priority is based on overriding: last created -> highest priority.
  # See how all your permissions lay out with "rake permissions" or simply "rake perms".

  # Examples
  #
  # You need to learn 4 commands: "can_role", "can_controller", "can_model" and "can"
  #
  # 1. The first command to learn is "can_role"
  #
  # using this command, means that role of user is allowed to perform ANY ACTION
  #
  #   can_role :admin, :developer, :master
  #

  # 2. Let's transform "can_role" into "role"
  #    and learn about the "can_model" and "can_controller" commands
  # 
  # 2.1. Example of "can_controller" and "can_model"
  #   role :manager do
  #     can_model :posts, :comments, :replies
  #     can_controller :manager_dashboard
  #   end

  # 3. Let's go further down the rabbit hole: "can_model" becomes "model" and we use the "can" command
  # 
  # 3.1. Example of "can", our manager cannot create or destroy users and managers
  #   role :manager do
  #     model :users, :managers do
  #       can :index, :show, :edit, :update
  #     end
  #     controller :admin_dashboard do
  #       can :index
  #     end
  #   end
  # 
  

  # Blocks
  # 
  # 1. All the four "can" commands can take a block
  #
  #   You can invoke any methods and instance variables available in your controller
  #   
  #   such as:
  #      current_user
  #      params
  #      session
  #      @posts
  # 
  #  Let's see some real and imaginary use cases
  # 
  #    role :user do
  #    
  #      can_controller :special_survey do
  #        current_user.id < 1000
  #      end
  #    
  #      model :posts do
  #    
  #        # admins might have blacklisted users to keep them from creating posts
  #        can(:new, :create) do
  #          BlacklistedUser.where(user_id: current_user.id).exists?
  #        end
  #    
  #        # users might block other users from accessing their profiles and posts
  #        can(:show) do
  #          @post.user.blocked_users.include?(current_user)
  #        end
  #    
  #        # a post can only be altered by their owner or admins
  #        can(:edit, :update, :destroy) do
  #          current_user.admin? || (current_user == @post.user)
  #        end
  #    
  #      end
  #    
  #    end

  # Message and Redirection
  # 
  # role :user do
  #
  #   can_controller :sign_up do
  #     {message: "You are already logged in.", redirect_to: home_path}
  #   end
  #
  #   model :secrets do
  #     can :index do
  #
  #       if current_user.email == 'chucknorris@gmail.com'
  #         true
  #       elsif Date.today.saturday? || Date.today.sunday?
  #         false # our website doesn't work on weekends, so no custom access messages are given
  #       else
  #         {redirect_to: sign_up_path, message: "Only Chuck Norris can access our secrets"}
  #       end
  #      
  #     end
  #   end
  #   
  # end


  # Learn more
  # https://github.com/yakko/permissions



end