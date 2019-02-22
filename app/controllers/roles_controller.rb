class RolesController < ApplicationController
  filter_resource_access

  def index
    @roles = Role.all
  end
  
  def show
    @role = Role.find(params[:id])
  end
  
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = "Rol creado exitosamente."
      redirect_to @role
    else
      render :action => 'new'
    end
  end
  
  def edit
    @role = Role.find(params[:id])
  end
  
  def update
    if params[:id] < 5 #Roles por defecto [Registrado, Desarrollador, Administrador, SuperAdministrador]
      flash[:error] = "Este rol no puede ser editado del sistema por ser un rol pre-definido."
      redirect_to roles_url
    else
      @role = Role.find(params[:id])
      if @role.update_attributes(params[:role])
        flash[:notice] = "Rol actualizado exitosamente."
        redirect_to @role
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    if params[:id] < 5 #Roles por defecto [Registrado, Desarrollador, Administrador, SuperAdministrador]
      flash[:error] = "Este rol no puede ser borrado del sistema por ser un rol pre-definido."
    else
      @role = Role.find(params[:id])
      @role.destroy
      flash[:notice] = "Rol borrado exitosamente."
    end

    redirect_to roles_url
  end
end
