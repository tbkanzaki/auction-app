class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update]
  before_action :set_product, only: [:show, :edit, :update]
  before_action :check_user, only: [:index, :new, :create, :edit, :update]

  def index
    @products = Product.joins(:category).order("categories.name, products.name")
  end

  def new
    @product = Product.new
    @categories = Category.order(:name)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Produto cadastrado com sucesso.'
    else
      @category = Category.all
      flash.now[:alert] = 'Não foi possível cadastrar o produto.'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Produto alterado com sucesso.'
    else
      @category = Category.all
      flash.now[:alert] = 'Não foi possível alterar o produto.'
      render :new
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :weight, :width, :height, :depth, :category_id, :product_image)
  end

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end
end
