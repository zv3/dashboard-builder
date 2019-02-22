class ThemesController < ApplicationController
  filter_resource_access

  def index
    themes_per_page = 7
    @search = Theme.searchlogic(params[:search])

    if has_role_with_hierarchy?(:administrador)
      @themes = @search.paginate :page => params[:page], 
        :per_page => themes_per_page,
        :include => :image
    elsif has_role_with_hierarchy?(:desarrollador) # si es desarrollador? all_public and my_themes
      @themes = @search.search(:all_public_or_from_user => current_user.id).paginate :page => params[:page], 
        :per_page => themes_per_page,
        :include => :image
    else  # si es invitado/registrado -> all_public
      @themes = @search.search(:all_public => true).paginate :page => params[:page],
        :per_page => themes_per_page,
        :include => :image
    end

    @categories = Category.type_of_themes
  end

  def apply
    @theme = Theme.find(params[:id])
    if logged_in?
      current_user.theme_id = @theme.id
      current_user.save
    else
      session[:theme_id] = @theme.id
    end

    flash[:notice] = "Tema a&ntilde;adido correctamente!."
    redirect_to root_url
  end
  
  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(params[:theme])
    @theme.user_id = current_user.id

    unless params[:image_remote_url].blank?
      image = Image.create(:image_remote_url => params[:image_remote_url])
      @theme.image_id = image.id if image.save!
    end

    # si admin -> aprobar
    if has_role_with_hierarchy?(:administrador)
      @theme.approved = true
      if @theme.save 
        flash[:notice] = "Widget registrado exitosamente." 
        redirect_to themes_path
      else
        render :action => 'edit'
      end
    else
      # asignamos rol de desarrollador
      current_user.role_id = Role.find_by_name("Desarrollador").id
      current_user.save

      @theme.approved = false
      if @theme.save  # guardamos
        # enviamos solicitud de inclusion en caso de registrarlo como publico
        if @theme.public?
          Request.new(
            :theme_id => @theme.id,
            :user_id => @theme.user_id,
            :message => "Espero su aprobacion. Saludos!",
            :request_type => 'T'
          ).save

          flash[:notice] = "Widget registrado exitosamente. Su inclusion debera ser aprobada por un administrador del sistema"
        else
          flash[:notice] = "Widget registrado exitosamente."
        end
        redirect_to themes_path
      else
        render :action => 'edit'
      end
    end
  end
    
  def edit
    @theme = Theme.find(params[:id])
  end
  
  def update
    @theme = Theme.find(params[:id])
    if @theme.update_attributes(params[:theme])
      if @theme.public? and not @theme.approved?
	    	Request.new(
					:theme_id => @theme.id,
					:user_id => @theme.user_id,
					:message => "Espero su aprobacion. Saludos!",
					:request_type => 'T'
				).save
				flash[:notice] = "Widget editado exitosamente. Su inclusion debera ser aprobada por el administrador del sistema"
			end
    	flash[:notice] = "Se actualizo con exito el tema. "
      redirect_to themes_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy
    flash[:notice] = "Tema borrado exitosamente."
    redirect_to themes_url
  end
    
end