class LotBidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lot, only: [:new, :create, :check_bid ]
  before_action :check_bid, only: [:create]

  def index
    @lot_winner = LotBid.select('MAX(bid), lot_id, lot_bids.user_id, bid').joins(:lot).where(lots: { status: 'closed' }).group(:lot_id)
  end

  def new
    @lot_bid = LotBid.new()
  end

  def create
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
    @bid = params[:lot_bid][:bid]
    @bid_max = LotBid.where(lot_id: params[:lot_id]).maximum(:bid)
    @bid_count = LotBid.where(lot_id: params[:lot_id]).count
    @lot_bid = LotBid.new()
    if @bid.to_i <= @lot.minimum_bid
      flash.now[:alert] = 'O lance tem que ser maior que o lance inicial'
      render :new
    elsif @bid_count > 0
      @bid_min = @bid_max + @lot.minimum_difference_bids
      if @bid.to_i <= @bid_max || @bid.to_i < @bid_min
        flash.now[:alert] = 'O lance tem que ser maior que o lance mínimo atual'
        render :new
      elsif !(Date.today.between?(@lot.start_date, @lot.limit_date))
        flash.now[:alert] = 'A data de hoje tem que estar dentro do prazo'
        render :new
      end
    end
  end

  private

  def set_lot
    @lot = Lot.find(params[:lot_id])
  end

end
