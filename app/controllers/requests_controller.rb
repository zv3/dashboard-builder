class RequestsController < ApplicationController
  filter_resource_access

  # lista las solicitudes
	def index
    @requests = Request.all
  end

  # muestra una solicitud
  def show
    @request = Request.find(params[:id])
    # verifica y carga segun tipo de solicitd
    case @request.request_type
    when 'W' then
      @widget = Widget.find_by_id(@request.widget_id)
    when 'T' then
      @theme = Theme.find_by_id(@request.theme_id)
    when 'C' then
      @comment = Comment.find_by_id(@request.comment_id)
    else
      flash[:error] = "Solicitud inválida"
    end
  end

  # instancia una nueva solicitud
  def new
	  @request = Request.new
    @request.request_type = params[:request_type]  
    # comentario
    if @request.request_type == 'C'
    	@request.user_id = params[:user_id]
	  	@request.comment_id = Comment.find_by_id(params[:id]).id
    end
  end

  # guarda la nueva solicitud  
  def create
    @request = Request.new(params[:request])
    if @request.save
      flash[:notice] = "Solicitud enviada."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  # borra una solicitud
  def destroy
    @request = Request.find(params[:id])
    # segun sea la solicitud, realizar diferentes acciones
    case @request.request_type
    when 'W' then # si es tipo widget  
  		@widget = Widget.find_by_id(@request.widget_id)
		  # si aprueba -> guarda widget y envia email de confirmacion
			if params[:approved] == 'T'
				@request.approved = true
				@widget.approved = true
				if @widget.save
  				@request.deliver_request_approve(request.host_with_port)
  				flash[:notice] = "Solicitud aprobada."
  			end
  			# si rechaza -> borra widget y envia email de rechazo
			else
				@request.approved = false
				@request.deliver_request_reject(request.host_with_port)
				@widget.destroy
			end
			@request.destroy
    # si es tipo theme
    when 'T' then
  		@theme = Theme.find_by_id(@request.theme_id)
  		# si aprueba -> publica theme y envia email de confirmacion
			if params[:approved] == 'T'
				@request.approved = true
				@theme.approved = true
				@request.deliver_request_approve(request.host_with_port)
				@theme.save
			else
			  # si rechaza -> envia email de rechazo
				@request.approved = false
				@request.deliver_request_reject(request.host_with_port)
			end
			@request.destroy
    # si es tipo comentario
    when 'C' then
      # si apueba -> borra comentario
			if params[:approved] == 'T'
				Comment.find_by_id(@request.comment_id).destroy
			else
				@request.destroy
			end
    end

    redirect_to requests_url
  end

end