class LotDoubtAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:index, :new, :create]
  before_action :set_lot_doubt, only: [:new, :create]

  def index
    @lot_doubt_answers = LotDoubt.includes(:lot_doubt_answer).where(lot_doubt_answers: { id: nil }).unblocked
  end

  def new
    @lot_doubt_answer = LotDoubtAnswer.new()
  end

  def create
    lot_doubt_answer_params = params.require(:lot_doubt_answer).permit(:answer)
    @lot_doubt_answer = LotDoubtAnswer.new(lot_doubt_answer_params)
    @lot_doubt_answer.user = current_user
    @lot_doubt_answer.lot_doubt = @lot_doubt 

    if @lot_doubt_answer.save
      redirect_to lot_doubt_answers_path, notice: 'Resposta salva com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível salvar a resposta.'
      render  :new
    end
  end

  private

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

  def set_lot_doubt
    @lot_doubt = LotDoubt.find(params[:lot_doubt_id])
  end

end
