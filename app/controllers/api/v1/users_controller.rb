# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
      before_action :set_user, only: %i[show update destroy]
      before_action :ensure_platform_ops!, only: %i[index create update destroy]

      def index
        render json: User.all, status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user)
              .permit(:email, :password, :password_confirmation, :role, :buyer_id)
      end

      def ensure_platform_ops!
        unless current_user.platform_ops?
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end
    end
  end
end
