class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update]
  before_action :check_user

  def index
    @categories = Category.order(:name)
    @category = Category.new()
  end
 
  def create
    @category = Category.new(category_params)
     
    if @category.save()
      redirect_to categories_path, notice: 'Categoria cadastrada com sucesso.'
    else
      @categories = Category.order(:name)
      flash.now[:alert] = 'Categoria não cadastrada.'
      render :index
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Categoria alterada com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível alterar a categoria.'
      render :index
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

  def category_params 
    params.require(:category).permit(:name)
  end

end
