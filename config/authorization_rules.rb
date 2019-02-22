authorization do
  role :guest do
    has_permission_on :users, :to => [:new, :create]
    has_permission_on :containers, :to => [:index, :show, :new, :create]
    has_permission_on :containers, :to => [:edit, :update, :delete, :destroy, :save_preferences] do
      if_attribute :user => is { user }
    end
    has_permission_on :tabs, :to => [:index, :show, :new, :create]
    has_permission_on :tabs, :to => [:edit, :update, :delete, :destroy] do
      if_attribute :session_id => is { user }
    end
    has_permission_on :categories, :to => [:index]
    has_permission_on :widgets, :to => [:index, :show]
    has_permission_on :themes, :to => [:index, :apply]
  end

  role :invitado do 
    includes :guest
  end

  role :registrado do
    includes :invitado
    has_permission_on :users, :to => [:edit, :update] do
      if_attribute :id => is { user.id }
    end
    has_permission_on :comments, :to => [:new, :create]
    has_permission_on :ratings, :to => [:new, :create]
    has_permission_on :widgets, :to => [:new, :create]
    has_permission_on :requests, :to => [:new, :create]
    has_permission_on :themes, :to => [:new, :create]
    has_permission_on :password_resets, :to => [:new, :create, :edit, :update]
  end

  role :desarrollador do
    includes :registrado

    has_permission_on :widgets, :to => [:edit, :update, :delete, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on [:groups], :to => [:new, :create, :index]
    has_permission_on [:groups], :to => [:show, :edit, :update, :delete, :destroy, :delete_widget, :add_widget, :delete_member, :add_member] do
      if_attribute :user => is { user }
    end
    has_permission_on :themes, :to => [:edit, :update, :delete, :destroy] do
      if_attribute :user => is { user }
    end
  end

  role :administrador do
    includes :desarrollador
    has_permission_on :widgets, :to => :manage
    has_permission_on :users, :to => :manage
    has_permission_on :categories, :to => :manage
    has_permission_on :roles, :to => :manage
    has_permission_on :comments, :to => :manage
    has_permission_on :ratings, :to => :manage
    has_permission_on :requests, :to => :manage
    has_permission_on :themes, :to => :manage
    has_permission_on :groups, :to => :manage
    has_permission_on :groups, :to => [:add_member, :add_widget, :delete_member, :delete_widget] 
  end

  role :superadministrador do
    includes :administrador
  end
end

privileges do
  privilege :manage do
    includes :index, :new, :create, :edit, :update, :delete, :destroy, :show
  end
end
    