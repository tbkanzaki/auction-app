class BlockedCpfsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user

  def index
    @blocked_cpfs = BlockedCpf.order(:name)
    @users = User.where(admin: false).order(:name)
    @blocked_cpf = BlockedCpf.new()
  end
 
  def create
    @blocked_cpf = BlockedCpf.new(blocked_cpf_params)
     
    if @blocked_cpf.save()
      redirect_to blocked_cpfs_path, notice: 'CPF cadastrado com sucesso.'
    else
      @blocked_cpfs = BlockedCpf.order(:name)
      @users = User.where(admin: false).order(:name)
      flash.now[:alert] = 'CPF não cadastrado.'
      render :index
    end
  end

  def destroy
    @blocked_cpf = BlockedCpf.find(params[:id])
    if @blocked_cpf.destroy
      redirect_to blocked_cpfs_path, notice: "CPF removido do bloqueio."
    else
      redirect_to blocked_cpfs_path, notice: 'Não foi possível remover o CPF do bloqueio.'
    end
  end 

  private

  def check_user
    if !current_user.admin?
      redirect_to root_path, alert: "Você não possui acesso a este módulo."
    end
  end

  def blocked_cpf_params 
    params.require(:blocked_cpf).permit(:cpf, :name)
  end

end
