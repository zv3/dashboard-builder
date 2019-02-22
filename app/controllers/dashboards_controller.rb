class DashboardsController < ApplicationController
  layout 'woo'

  # carga los tabs/contenedores del dashboard en la variable javascript 'app', para que luego sea cargado dinamicamente manipulando el DOM.
  def index
    @tabs = load_tabs
		@containers = Container.all :conditions => ["tab_id IN (?)", @tabs.collect{ |t| t.id } ], 
		  :include => :widget

    @app = Hash.new
    @app['userData'] = Hash.new

    unless @theme.nil?
      @app['userData']['topbg'] = @theme.image.data.url
      @app['userData']['cColor'] = @theme.color.blank? ? '#148EA4' : @theme.color
      @app['userData']['cFont'] =  @theme.font
    end

    @app['userData']['tabs'] = @tabs.collect{ |t| {
      :id => t.id, 
      :title => t.title, 
      :layout => t.layout,
      :cols => t.layout.to_i
    } }
    @app['userData']['containers'] = @containers.collect{ |c| {
      :id => c.id, 
      :widgetId => c.widget.id,
      :widgetURL => c.widget.url,
      :title => c.widget.name,
      :tab => c.tab.id,
      :col => c.column.to_i,
      :row => c.order,
      :widgetPreferences => ActiveSupport::JSON.decode(c.widget.preferences),
      :preferenceValues => c.widgetparams.map { |p| {:name => p.name, :value =>  p.value} }
    } }
	end
end