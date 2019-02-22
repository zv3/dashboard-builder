class GroupsMembersController < ApplicationController
	#filter_resource_access

  def index
    @group = Group.find(params[:group_id])
  	@group_id = params[:group_id]
  	@users = @group.users
    @groups_users = GroupsUsers.all :conditions => {:group_id, @group_id}
  end
  
  def new
    @group = Group.find(params[:group_id])
    @user = User.new
  end
  
  def create
    @group = Group.find(params[:group_id])
    @groups_users = GroupsUsers.new

    @user = User.find_by_username(params[:user][:username])  || User.new
    if @user.try(:id).blank?
    	@user.errors.add 'username'
    	render :action => 'new'
    else
      @groups_users.group_id = @group.id
      @groups_users.user_id = @user.id
    	@groups_users.save
      flash[:notice] = "Usuario añadido exitosamente al grupo."
      redirect_to group_members_path(@group)
    end
  end
  
  def destroy
    @group = Group.find(params[:group_id])
    @groups_users = GroupsUsers.find(params[:id])
    @groups_users.destroy
    flash[:notice] = "Usuario borrado exitosamente del grupo."
    redirect_to group_members_path(@group)
  end
end
