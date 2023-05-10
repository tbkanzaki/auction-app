class LotItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user

  def new
    @lot = Lot.find(params[:lot_id])
    @lot_item = LotItem.new()
    @products = Product.unblocked.order(:name)
  end

  def create
    @lot = Lot.find(params[:lot_id])
    lot_item_params = params.require(:lot_item).permit(:product_id)

    if @lot.lot_items.create(lot_item_params)
      product = Product.find(lot_item_params[:product_id])
      product.blocked!
      redirect_to @lot, notice: 'Item adicionado com sucesso.'
    else
      @products = Product.unblocked.order(:name)
      flash.now[:alert] = 'Não foi possível adicionar o item.'
      render :new
    end
  end

  def destroy
    @lot = Lot.find(params[:lot_id])
    @lot_item = LotItem.find(params[:id])
    @product = @lot_item.product
    if @lot_item.destroy
      @product.unblocked! 
      redirect_to @lot, notice: "Item removido com sucesso."
    else
      redirect_to @lot, notice: 'Não foi possível remover o item.'
    end
  end

  private
  
  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

end
