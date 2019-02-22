class RatingsController < ApplicationController
  filter_resource_access	
  
  # instancia un nuevo rating
	def new
		@rating = Rating.new
		@rating.widget_id = Widget.find_by_id(params[:widget_id]).id
		# verificamos si el usuario ya puntuo el widget
		@rate = Rating.find(:all, :conditions => {:widget_id => @rating.widget_id, :user_id => current_user.id}).first
		if @rate.nil?
			@rate = 0
		else
			@rate = @rate.rate
		end
	end
	
	# guardamos la puntuacion
	def create
		@rating = Rating.new(params[:rating])
  	@rating.user_id = current_user.id
    if @rating.save
      redirect_to widget_path(@rating.widget_id)
    end
	end
	
end