class LotsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :approved, :closed , :cancelled]

  before_action :check_user, only: [:index, :new, :create, :approved, :closed , :cancelled]
  before_action :set_lot, only: [:show, :approved, :closed , :cancelled ]

  def index
    @lots = Lot.order(:start_date, :limit_date)
    @waiting_approval_lots = Lot.waiting_approval.order(:start_date, :limit_date)
    @approved_in_progress_lots = Lot.approved.where("start_date <= ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
    @approved_future_lots = Lot.approved.where("start_date > ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
    @approved_expired_lots = Lot.where("limit_date < ?", Date.today).order(:start_date, :limit_date)
    @cancelled_lots = Lot.cancelled.order(:start_date, :limit_date)
    @closed_lots = Lot.closed.order(:start_date, :limit_date)
  end

  def new
    @lot = Lot.new
  end

  def create
    @lot = Lot.new(lot_params)
    @lot.user = current_user

    if @lot.save
      redirect_to @lot, notice: 'Lote cadastrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível cadastrar o lote.'
      render :new
    end
  end

  def show
    @lot_doubts = LotDoubt.where(lot: @lot).unblocked
    @favorite_lot_user = @lot.favorite_lots.find_by(user_id: current_user.id) if user_signed_in?
    
    @lot_bid = Lot.new
    if @lot.approved?
      @lot_approver = LotApprover.where(lot_id: @lot).first
    end
    @bid_max = LotBid.where(lot_id: @lot).maximum(:bid)
    if params[:user].present?
      @winner_user = User.find(params[:user])
    end
  end

  def approved
    @lot_approver = LotApprover.new(lot: @lot, user: current_user)
    if @lot_approver.save
      @lot.approved! 
      redirect_to @lot, notice: 'Lote aprovado com sucesso.'
    else
      redirect_to @lot, alert: 'Não foi possível aprovar o lote.'
    end
  end
  
  def closed
    @lot.closed! 
    @lot.lot_items.each do |item|
      product = Product.find(item.product.id)
      product.sold!
    end
    redirect_to @lot, notice: 'Lote encerrado com sucesso.'
  end

  def cancelled
    @lot.cancelled! 
    @lot.lot_items.each do |item|
      product = Product.find(item.product.id)
      product.unblocked!
    end
    redirect_to @lot, notice: 'Lote cancelado com sucesso.'
  end

  private

  def set_lot
    @lot = Lot.find(params[:id])
  end
  
  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

  def lot_params
    params.require(:lot).permit(:code, :start_date, :limit_date, :minimum_bid, :minimum_difference_bids)
  end
  
end
