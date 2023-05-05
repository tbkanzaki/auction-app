class CategoriesController< ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :check_user

  def new
    @category = Category.new()
  end

  def create
    category_params = params.require(:category).permit(:name)
    @category = Category.new(category_params)
     
    if @category.save()
      redirect_to root_path, notice: 'Categoria cadastrada com sucesso.'
    else
      flash.now[:alert] = 'Categoria não cadastrada.'
      render :new
    end
  end

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

end