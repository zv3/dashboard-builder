class TabsController < ApplicationController
  # instancia una nueva pestanha
  def new
    @tab = Tab.new
  end

  # guarda la pestana
  def create
    respond_to do |format|
      @tab = Tab.new(params[:tab])

      if logged_in?
      	@tab.user = current_user
      else
      	@tab.session_id = session[:session_id]
      end

      if @tab.save
        format.js { render :json => {:success => true, :tab => @tab} }
      else
        format.js { render :json => {:success => false} }
      end
    end
  end

  # edita la pestana
  def edit
    @tab = Tab.find(params[:id])
  end

  # guarda los cambios editados  
  def update
    respond_to do |format|
      @tab = Tab.find(params[:id])
      @tab.update_attributes(params[:tab])

      if @tab.update_attributes(params[:tab])
        format.js { render :json => {:success => true} }
      else
        format.js { render :json => {:success => false} }
      end
    end
  end

  # borra la pestanha
  def destroy
    @tab = Tab.find(params[:id], :conditions => ['session_id = ? OR user_id = ?', session[:session_id], current_user.try(:id)])
    if @tab.destroy
      flash[:notice] = "Pestaña borrada exitosamente."
    else
      flash[:error] = "Se produjo un error al querer borrar la pestaña."
    end
    redirect_to root_url
  end
end
