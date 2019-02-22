class UsersController < ApplicationController
  filter_resource_access

  # lista a los usuarios del sistema segun rol
  def index
    if has_role_with_hierarchy?(:superadministrador)
      # muestra todos los usuarios, excepto al superaministrador
      @users = User.all :conditions => ['role_id != ?', 4]
    else
      # muestra todos los usuarios (registrados y desarrolladores), excepto a los otros administradores
      @users = User.all :conditions => ['role_id <= ?', 2]
    end
  end

  # instancia un nuevo usuario
  def new
    # si esta logueado > ya existe usuario
    if logged_in?
      flash[:error] = "Usted ya posee una cuenta en el sistema."
      redirect_to root_url
    end

    @user = User.new
    @user.role = Role.find_by_name('Registrado')
  end

  # guarda cuenta (c/ rol registrado) y envia un email de activacion de cuenta
  def create
    @user = User.new(params[:user])
    @user.role = Role.find_by_name('Registrado')
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!(request.host_with_port)
      flash[:notice] = "Su cuenta ha sido creada satisfactoriamente. Por favor, revise su email y siga las instrucciones para activar su cuenta!"
      redirect_to root_url
    else
      render :action => :new
    end
  end

  # edita usuario
  def edit
    @user = User.find(params[:id])
  end

  # guarda actualizaciones
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Perfil editado exitosamente."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Usuario borrado exitosamente."
    else
      flash[:error] = "Se produjo un error al querer borrar el widget."
    end
    redirect_to users_path     
  end
end
