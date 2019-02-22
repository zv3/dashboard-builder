class WidgetsController < ApplicationController
  filter_resource_access

  # lista widgets segun rol
  def index
    widgets_per_page = 7
    @search = Widget.searchlogic(params[:search])

    if params[:shared] && has_role_with_hierarchy?(:registrado)
      @groups = Group.all :conditions => ["id IN (?)", GroupsUsers.find(:all, :conditions => { :user_id => current_user.id }).map(&:group_id).join(',').to_i]
      @widgets = Widget.all :conditions => ["id IN (?)", GroupsWidgets.find(:all, :conditions => ["group_id IN (?)", @groups.map(&:id).join(',').to_i]).map(&:widget_id).join(',').to_i]
    elsif params[:my_widgets] && has_role_with_hierarchy?(:registrado)
      @widgets = Widget.all :conditions => { :user_id => current_user.id, :approved => true }
    else
      # si admin/superadmin? all_widgets : all_public and my_widgets
      if has_role_with_hierarchy?(:administrador) 
        @widgets = @search.paginate :page => params[:page], 
          :conditions => { :approved => true },
          :per_page => widgets_per_page
      else
        @widgets = @search.paginate :page => params[:page], 
          :conditions => { :public => true, :approved => true },
          :per_page => widgets_per_page
      end
    end
        
    @categories = Category.type_of_widgets
  end

  # muestra los datos de un widgets
	def show
		@widget = Widget.find(params[:id])
		@rate = @widget.ratings.average :rate
	end

  # instancia un nuevo widget
  def new
    @widget = Widget.new
  end

  # guarda el nuevo widget
  def create
    @widget = Widget.new(params[:widget])
    @widget.user_id = current_user.id

    unless params[:image_remote_url].blank?
      image = Image.create(:image_remote_url => params[:image_remote_url])
      if image.save
        @widget.image_id = image.id
      end
    else
      @widget.image_id = Image.find_by_data_file_name('logovq.png').id
    end

    # si admin/superadmin -> aprobar (no necesita aprobar via request)
    if has_role_with_hierarchy?(:administrador)
      @widget.approved = true
      if @widget.save
        flash[:notice] = "Widget registrado exitosamente."
        redirect_to widgets_path
      else
        render :action => 'new'
      end
    else
      # asignamos rol de desarrollador
      current_user.role_id = Role.find_by_name("Desarrollador").id
      current_user.save

      # guardamos y enviamos solicitud de inclusion
      @widget.approved = false
      if @widget.save
        Request.new(
          :widget_id => @widget.id,
          :user_id => @widget.user_id,
          :message => "Espero su aprobacion. Saludos!",
          :request_type => 'W'
        ).save
        flash[:notice] = "Widget registrado exitosamente. Su inclusion debera ser aprobada por el administrador del sistema"
        redirect_to root_url
      else
        render :action => 'new'
      end
    end
  end

  # edita un widget
  def edit
    @widget = Widget.find(params[:id])
  end

  def update
    @widget = Widget.find(params[:id])
    image = Image.create(:image_remote_url => params[:image_remote_url]) 

    #borra los tags anteriores, para dar lugar a los nuevos
    @widget.tags.destroy_all
    # si existe url de la imagen, asignarla ; sino asignar imagen por default
     if image.save
       @widget.image_id = image.id
     else
       @widget.image_id = Image.find_by_data_file_name('logovq.png').id
     end
     # actualiza atributos
    if @widget.update_attributes(params[:widget])
      flash[:notice] = "Widget actualizado exitosamente."
      redirect_to widgets_path
    else
      render :action => 'edit'
    end
  end

  # borra widget
  def destroy
    @widget = Widget.find(params[:id])
    if @widget.destroy
      flash[:notice] = "Widget borrado exitosamente."
    else
      flash[:error] = "Se produjo un error al querer borrar el widget."
    end
    redirect_to widgets_path     
  end
end
