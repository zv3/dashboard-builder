class CategoriesController < ApplicationController
  filter_resource_access

  # lista las categorias
  def index
    @categories = Category.all
  end

  # muestra una categoria
  def show
    @category = Category.find(params[:id])
  end

  # instancia una nueva categoria
  def new
    @category = Category.new
  end

  # guarda la categoria nueva
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Categoría creada exitosamente."
      redirect_to categories_url
    else
      render :action => 'new'
    end
  end
  
  # edita una categoria
  def edit
    @category = Category.find(params[:id])
  end

  # guarda los cambios editados de una categoria  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Categoría actualizada exitosamente."
      redirect_to categories_url
    else
      render :action => 'edit'
    end
  end
  
  # borra una categoria  
  def destroy
    @category = Category.find(params[:id])

    @category.destroy
    flash[:notice] = "Categoría borrada exitosamente."
    redirect_to categories_url
  end
end
