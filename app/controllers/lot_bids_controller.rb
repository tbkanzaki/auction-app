class LotBidsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_bid, only: [:create]

  def new
    @lot = Lot.find(params[:lot_id])
    @lot_bid = LotBid.new()
  end

  def create
    @lot = Lot.find(params[:lot_id])
    lot_bid_params = params.require(:lot_bid).permit(:bid)
    
     @lot_bid = LotBid.new(lot_bid_params)
     @lot_bid.user = current_user
     @lot_bid.lot = @lot

    if @lot_bid.save
      redirect_to @lot, notice: 'Lance feito com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível fazer o lance.'
      render :new
    end
  end

  def check_bid
    @lot = Lot.find(params[:lot_id])
    @bid = params[:lot_bid][:bid]
    @bid_max = LotBid.where(lot_id: params[:lot_id]).maximum(:bid)
    @bid_count = LotBid.where(lot_id: params[:lot_id]).count
    @lot_bid = LotBid.new()
    if @bid.to_i <= @lot.minimum_bid
      flash.now[:alert] = 'O lance tem que ser maior que o lance mínimo'
      render :new
    elsif @bid_count > 0
      @bid_min = @bid_max + @lot.minimum_difference_bids
      if @bid.to_i <= @bid_max || @bid.to_i < @bid_min
        flash.now[:alert] = 'O lance tem que ser maior que o lance mínimo'
        render :new
      elsif !(Date.today.between?(@lot.start_date, @lot.limit_date))
        flash.now[:alert] = 'A data de hoje tem que estar dentro do prazo'
        render :new
      end
    end
  end
end
