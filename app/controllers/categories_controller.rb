class CategoriesController< ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :check_user

  def index
    @categories = Category.order(:name)
    @category = Category.new()
  end
 
  def create
    category_params = params.require(:category).permit(:name)
    @category = Category.new(category_params)
     
    if @category.save()
      redirect_to categories_path, notice: 'Categoria cadastrada com sucesso.'
    else
      @categories = Category.all.order(:name)
      flash.now[:alert] = 'Categoria não cadastrada.'
      render :index
    end
  end

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

end