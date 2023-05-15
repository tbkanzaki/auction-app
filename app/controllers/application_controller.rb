class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_user_blocked

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end

  def check_user_blocked
    if user_signed_in? && current_user.blocked?
      sign_out current_user
      flash[:alert] = "Seu CPF está bloqueado. Você não pode fazer lances em leilões."
      redirect_to root_path
    end
  end

end
