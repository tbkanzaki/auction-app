class LotsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  before_action :set_lot, only: [:show, :edit, :update]

  def index
    @lots = Lot.order(:start_date, :limit_date)
    @waiting_approval_lots = Lot.waiting_approval.order(:start_date, :limit_date)
    @approved_in_progress_lots = Lot.approved.where("start_date <= ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
    @approved_future_lots = Lot.approved.where("start_date > ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
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
