module Api
  module V1
    class ProgrammesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action       :authenticate_user!
      before_action       :ensure_buyer_or_platform_ops!
      before_action       :set_buyer
      before_action       :set_programme, only: %i[show update destroy]

      def index
        render json: @buyer.programmes
      end

      def show
        render json: @programme
      end

      def create
        @programme = @buyer.programmes.build(programme_params)
        if @programme.save
          render json: @programme, status: :created
        else
          render json: { errors: @programme.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @programme.update(programme_params)
          render json: @programme
        else
          render json: { errors: @programme.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @programme.destroy
        head :no_content
      end

      private

      def set_buyer
        @buyer = Buyer.find(params[:buyer_id])
      end

      def set_programme
        @programme = @buyer.programmes.find(params[:id])
      end

      def programme_params
        params.require(:programme)
              .permit(:name, :limit, :fee_percent, :maturity_days)
      end

      def ensure_buyer_or_platform_ops!
        unless current_user.buyer_admin? || current_user.platform_ops?
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end
    end
  end
end
