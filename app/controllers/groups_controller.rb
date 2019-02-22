class GroupsController < ApplicationController
	filter_resource_access

  # lista los grupos de acuerdo a los roles
	def index
		# si rol mayor a desarrollador, listar todos los grupos    
  	if has_role_with_hierarchy?(:administrador) 
			@groups = Group.all
		# si rol es desarrollador, listar solo sus grupos
		else
			@groups = Group.all :conditions => { :user_id, current_user.id }
		end
  end

  def show
    @group = Group.find(params[:id])

    # si el grupo esta vacio (sin widgets)
    if has_role_with_hierarchy?(:desarrollador)
      @widgets = current_user.widgets.all :conditions => ["approved=? AND public=?", true, false]
    end
  end

  # agrega un miembro al grupo
  def add_member
    @group = Group.find(params[:id])
    @user = User.find_by_username(params[:username])

    unless @user.nil? || @group.users.include?(@user)
      @group.users << @user
      flash[:notice] = "Miembro añadido exitosamente." if @group.save
    else
      flash[:error] = "No se pudo añadir a este usuario. Verifique que el usuario a añadir sea el correcto."
    end

    redirect_to group_path(@group)
  end

  # borra un miembro del grupo
  def delete_member
    @group = Group.find(params[:id])
    @user = User.find_by_id(params[:user_id])

    if @group.users.include?(@user)
      @group.users.delete(@user)
      @group.save
      flash[:notice] = "Miembro borrado exitosamente."
    end

    redirect_to group_path(@group)
  end

  # agrega un widget al grupo
  def add_widget
    @group = Group.find(params[:id])
    @widget = Widget.find_by_id(params[:widget][:widget_id], :conditions => { :approved => true, :public => false, :user_id => current_user.id})

    unless @widget.nil?
      @group.widgets << @widget
      flash[:notice] = "Widget añadido exitosamente." if @group.save
    else
      flash[:error] = "No se pudo añadir este widget. Verifique que el widget a añadir sea el correcto."
    end

    redirect_to group_path(@group)
  end

  def delete_widget
    @group = Group.find(params[:id])
    @widget = Widget.find_by_id(params[:widget_id])

    if @group.widgets.include?(@widget)
      @group.widgets.delete(@widget)
      @group.save
      flash[:notice] = "Widget borrado exitosamente."
    end

    redirect_to group_path(@group)
  end

  # instancia grupo nuevo
  def new
    @group = Group.new
  end

  # guarda el nuevo grupo
  def create
    @group = Group.new(params[:group])
    @group.user_id = current_user.id
    if @group.save
      flash[:notice] = "Grupo creado exitosamente."
      redirect_to groups_path
    else
      render :action => 'new'
    end
  end

  # edita un grupo
  def edit
    @group = Group.find(params[:id])
  end

  # guarda los cambios sobre un grupo
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = "Grupo actualizado."
      redirect_to groups_path
    else
      render :action => 'edit'
    end
  end

  # borra un grupo
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "Grupo borrado."
    redirect_to groups_url
  end
end