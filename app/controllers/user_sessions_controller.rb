class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  # instancia nuevo sesion
  def new
    @user_session = UserSession.new
  end

  # crea nueva sesion
  def create
    @user_session = UserSession.new(params[:user_session])
   
    user = User.find_by_username(@user_session.username)
    # user = current_user
    # verifica si usuario no esta baneado
    if not user.nil? and user.banned? 
      flash[:error] = "Usuario baneado!"
      redirect_to root_url
    else
      if @user_session.save
        flash[:notice] = "Usuario logueado correctamente!"
        redirect_to_target_or_default root_url
      else
        render :action => 'new'
      end
    end
  end

  # borra sesion  
  def destroy
    current_user_session.destroy
    #flash[:notice] = "Logout successful!"
    redirect_to_target_or_default root_url
  end
end
