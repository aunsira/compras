class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_omise_token
    unless params[:omise_token].present?
      @token = nil
      flash.now.alert = t("shopping.failure")
      redirect_to shops_path
    end
  end
end
