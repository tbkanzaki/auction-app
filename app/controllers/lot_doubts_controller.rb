class LotDoubtsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:edit, :update, :blocked, :unblocked]
  before_action :set_lot, only: [:new, :create]

  def new
    @lot_doubt = LotDoubt.new()
  end

  def create
    lot_doubt_params = params.require(:lot_doubt).permit(:question)
    @lot_doubt = LotDoubt.new(lot_doubt_params)
    @lot_doubt.user = current_user
    @lot_doubt.lot = @lot

    if @lot_doubt.save
      redirect_to lot_path(@lot), notice: 'Pergunta salva com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível salvar a pergunta.'
      render :new
    end
  end

  def blocked
    @lot_doubt = LotDoubt.find(params[:id])
    @lot_doubt.blocked! 
    redirect_to lot_doubt_answers_path, notice: 'Pergunta bloqueada com sucesso.'
  end

  private

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

  def set_lot
    @lot = Lot.find(params[:lot_id])
  end
  
end
