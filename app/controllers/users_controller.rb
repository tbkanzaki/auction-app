class UsersController < ApplicationController

  def blocked
    @user = User.find(params[:id])
    @user.blocked! 
    @blocked_cpfs = BlockedCpf.order(:name)
    @users = User.order(:name)
    redirect_to blocked_cpfs_path, notice: 'Usuário bloqueado com sucesso.'
  end

  def unblocked
    @user = User.find(params[:id])
    @user.unblocked! 
    @blocked_cpfs = BlockedCpf.order(:name)
    @users = User.order(:name)
    redirect_to blocked_cpfs_path, notice: 'Usuário desbloqueado com sucesso.'
  end

end