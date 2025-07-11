# app/controllers/api/v1/buyers_controller.rb
module Api
  module V1
    class BuyersController < ApplicationController
      # Turn off CSRF for JSON/API requests
      skip_before_action :verify_authenticity_token

      before_action -> { request.format = :json }

      before_action :authenticate_user!                                # Devise JWT
      before_action :ensure_buyer_or_platform_ops!, only: %i[create update destroy]
      before_action :set_buyer,            only: %i[show update destroy]

      def index
        render json: Buyer.all.as_json(include: { users: { only: [:id, :email, :role] } })
      end

      def show
        render json: @buyer.as_json(include: { users: { only: [:id, :email, :role] } })
      end

      def create
        @buyer = Buyer.new(buyer_params)

        if attrs = buyer_params[:users_attributes]
          attrs.first[:role] ||= "buyer_admin"
        end

        if @buyer.save
          render json: @buyer, status: :created
        else
          render json: { errors: @buyer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @buyer.update(buyer_params)
          render json: @buyer.to_json(include: :users)
        else
          render json: { errors: @buyer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @buyer.destroy
        head :no_content
      end

      private

      def set_buyer
        @buyer = Buyer.find(params[:id])
      end

      def buyer_params
        params.require(:buyer).permit(
          :name, :registration_number, :address, :contact_email,
          users_attributes: %i[id email password password_confirmation role _destroy]
        )
      end

      # allow both buyer_admin _and_ platform_ops to manage buyers
      def ensure_buyer_or_platform_ops!
        unless current_user.buyer_admin? || current_user.platform_ops?
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end
    end
  end
end
