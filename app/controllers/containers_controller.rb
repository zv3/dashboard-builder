class ContainersController < ApplicationController
  # crea un nuevo contenedor
  def new
    @container = Container.new
    @container.widget_id = Widget.find_by_id(params[:widget_id]).id
    @tabs = load_tabs
  end

  # instancia un nuevo contenedor
  def create
    @container = Container.new(params[:container])
    @container.column = 0
    if @container.save
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  # edita un contenedor
  def edit
    @container = Container.find(params[:id])
  end

  def save_preferences
    respond_to do |format|
      @container = Container.find(params[:id])
      @container.widgetparams.destroy_all

      params[:widgetparams].map do |name, value|
        unless value.blank?
          @container.widgetparams << Widgetparam.new(:name => name, :value => value)
        end
      end

      if @container.save
        format.js { render :json => { :success => true } }
      else
        format.js { render :json => { :success => false } }
      end
    end
  end

  # guarda los cambios editados del contenedor
  def update
    respond_to do |format|
      @container = Container.find(params[:id])
      if @container.update_attributes(params[:container])
        format.html { redirect_to root_url }
        format.js { render :json => { :success => true } }
      else
        format.html { render :action => 'edit' }
        format.js { render :json => { :success => false } }
      end
    end
  end

  # borra un contenedor
  def destroy
    @container = Container.find(params[:id])
    @container.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { render :json => { :success => true } }
    end
  end
end
