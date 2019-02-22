 class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
    current_user_session.destroy if current_user_session
    # carga usuario c/ token_perishable == activation_code
    @user = User.find_by_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    # activar usuario; enviar email de confirmacion de cuenta; crear nueva sesion
    if @user.activate!
      @user.deliver_activation_confirmation!(request.host_with_port)
      UserSession.create(@user)
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def create
    @user = User.find(params[:id])
    raise Exception if @user.active?
    if @user.activate!
      @user.deliver_activation_confirmation!(request.host_with_port)
      flash[:notice] = "Su cuenta ha sido activada correctamente!."
      redirect_to root_url
    else
      render :action => :new
    end
  end

end