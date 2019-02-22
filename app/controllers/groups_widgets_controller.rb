class GroupsWidgetsController < ApplicationController
  #filter_resource_access
	
	def index
    @group = Group.find(params[:group_id])
		@groups_widgets = GroupsWidgets.all :conditions => {:group_id, @group_id}
		@widgets = @group.widgets
  end

  def new
    @group = Group.find(params[:group_id])
    @widget = Widget.new
    @groups_widgets = GroupsWidgets.new
    @groups_widgets.group_id = params[:group_id]
    # si el grupo esta vacio (sin widgets)
    if GroupsWidgets.find(:all, :conditions => {:group_id,params[:group_id]}).empty?
    	# si tiene rol mayor que desarrollador -> listar todos
    	if current_user.role_id > 2
    		@widgets = Widget.all
			# si tiene rol de desarrollador -> listar solo sus widgets    	
  		else
    		@widgets = Widget.all :conditions => {:user_id, current_user.id}
    	end
    # si ya existen widgets en el grupo
  	else
  		# si tiene rol mayor que desarrollador -> listar todos los que todavia no incluyo 
  		if current_user.role_id > 2
  			@widgets = Widget.all :conditions => ["id NOT IN (?)", GroupsWidgets.find(:all, :conditions => {:group_id,params[:group_id]}).collect{|w|w.widget_id}]
  		# si tiene rol de desarrollador -> listar todos sus widgets que todavia no incluyo
			else
  			@widgets = Widget.all :conditions => ["id NOT IN (?) AND user_id=?", GroupsWidgets.find(:all, :conditions => {:group_id,params[:group_id]}).collect{|w|w.widget_id}, current_user.id]
  		end
    end
  end
  
  def create
    @group = Group.find(params[:group_id])
    @groups_widgets = GroupsWidgets.new(params[:groups_widgets])
    @groups_widgets.group_id = @group.id
    if @groups_widgets.save
      flash[:notice] = "Widget añadido exitosamente."
      redirect_to group_widgets_path(:group_id => @groups_widgets.group_id)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @group = Group.find(params[:group_id])
    @groups_widgets = GroupsWidgets.find(params[:id])
    @groups_widgets.destroy
    flash[:notice] = "Widget ya no pertenece al grupo."
    redirect_to group_widgets_path(@group)      
  end
end
