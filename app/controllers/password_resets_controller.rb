class PasswordResetsController < ApplicationController
	before_filter :load_user_using_perishable_token, :only => [:edit, :update]
	before_filter :require_no_user
	
	def new
	end

	# genera email para restablecer contrasenha del usuario
	def create
    @user = User.find_by_email(params[:email])
    # si existe el usuario con el email especificado, enviar email; sino desplegar error
    if @user
      @user.deliver_password_reset_instructions!(request.host_with_port)
      flash[:notice] = "Las instrucciones para restablecer su contraseña se han enviado a su correo electrónico."
      redirect_to root_path
    else
      flash[:error] = "No se encontro un usuario con el email #{params[:email]}"
      render :action => :new
    end
  end

  def edit
  end

  # restablece contrasenha del usuario
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Su contraseña se ha actualizado correctamente."
      redirect_to root_url
    else
    	flash[:error] = params[:user][:password]
      render :action => :edit
    end
  end


  private
  # busca al usuario q tiene perishable_token
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Lo sentimos, pero no pudimos localizar su cuenta."
      redirect_to root_url
    end
  end

	
end