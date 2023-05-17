class FavoriteLotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_lots_approved_in_progres = FavoriteLot.left_outer_joins(:lot).where("lots.start_date <= ? AND lots.limit_date >= ? AND lots.status = ? AND favorite_lots.user_id = ?", Date.today, Date.today, 3,current_user.id).order(:start_date, :limit_date)
    @favorite_lots_approved_expired = FavoriteLot.left_outer_joins(:lot).where("limit_date < ? AND lots.status = ? AND favorite_lots.user_id = ?", Date.today, 3,current_user.id).order(:start_date, :limit_date)   
  end
  
  def create
    @lot = Lot.find(params[:lot_id])
    @favorite_lot = FavoriteLot.new(lot: @lot, user: current_user)
    if @favorite_lot.save
      redirect_to lot_path(@lot), notice: 'Lote favoritado com sucesso.'
    else
      redirect_to lot_path(@lot), alert: 'Não foi possível favoritar o lote.'
    end
  end

  def destroy
    @lot = Lot.find(params[:lot_id])
    @favorite_lot = FavoriteLot.find(params[:id])
    if @favorite_lot.destroy
      redirect_to lot_path(@lot), notice: "Lote removido dos favoritos com sucesso."
    else
      redirect_to lot_path(@lot), notice: 'Não foi possível remover o lote dos favoritos'
    end
  end 
end
