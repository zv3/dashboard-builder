# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'woo'
  include Authentication
  helper :all
  filter_parameter_logging :password, :password_confirmation
  before_filter { |c| Authorization.current_user = c.current_user }

  # comunica y redirecciona al usuario en caso de no poseer los permisos de acceso
  def permission_denied
    flash[:error] = "Usted no tiene permisos para acceder a esta pagina."
    redirect_to root_url
  end

  private
    # requiere un usuario logueado para acceder a una pagina
    def require_user
      unless logged_in?
        store_target_location
        flash[:notice] = "Debe iniciar sesion para poder acceder a esta pagina"
        redirect_to login_url
        return false
      end
      true
    end

    # requiere un usuario no logueado
    def require_no_user
      if current_user
        store_target_location
        flash[:notice] = "Debe iniciar sesion para poder acceder a esta pagina"
        redirect_to login_url
        return false
      end
    end

    # carga/crea pestanas/contenedores > si logueado desde db ; sino desde cookie
    def load_tabs
      if logged_in?
        tabs = current_user.tabs.all :include => :containers
        @theme = Theme.find_by_id(current_user.theme_id)
      else
        @theme = Theme.find_by_id(session[:theme_id])
        tabs = Tab.all :conditions => { :session_id => session[:session_id]}, 
          :include => :containers, 
          :order => "id ASC"
      end

      if tabs.blank?
        tab = Tab.new { |t|
          t.title = 'General'
          if logged_in?
            t.user = current_user 
          else 
            t.session_id = session[:session_id] 
          end
          t.layout = "2-0"
          t.containers << Container.new { |c| 
            c.widget_id = Widget.first.id 
            c.column = 0
          }
        }
        tab.save
        tabs << tab
      end
      tabs
    end
end
