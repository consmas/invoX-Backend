class Users::MeController < ApplicationController
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session

  before_action :authenticate_user!

  def show
    render json: {
      user: {
        id:    current_user.id,
        email: current_user.email,
        role:  current_user.role
      }
    }
  end
end
