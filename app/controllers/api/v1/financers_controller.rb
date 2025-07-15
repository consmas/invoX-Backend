# app/controllers/api/v1/financers_controller.rb
module Api
  module V1
    class FinancersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
      before_action :ensure_platform_ops!, only: %i[index create update destroy]
      before_action :set_financer,        only: %i[show update destroy portfolio]

      # GET /api/v1/financers
      def index
        render json: Financer.all, status: :ok
      end

      # GET /api/v1/financers/:id
      def show
        render json: @financer, status: :ok
      end

      # POST /api/v1/financers
      def create
        @financer = Financer.new(financer_params.merge(role: :financer))
        if @financer.save
          render json: @financer, status: :created
        else
          render json: { errors: @financer.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/financers/:id
      def update
        if @financer.update(financer_params)
          render json: @financer, status: :ok
        else
          render json: { errors: @financer.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/financers/:id
      def destroy
        @financer.destroy
        head :no_content
      end

      # GET /api/v1/financers/:id/portfolio
      # returns all invoices this financer has funded
      def portfolio
        invoices = @financer.funded_invoices.includes(:bids, :supplier)
        render json: invoices.as_json(include: {
                                         bids:   { only: %i[id amount status expiry_date] },
                                         supplier: { only: %i[id email] }
                                       }), status: :ok
      end

      private

      def set_financer
        @financer = Financer.find(params[:id])
      end

      def financer_params
        params.require(:financer)
              .permit(:email, :password, :password_confirmation)
      end

      def ensure_platform_ops!
        return if current_user.platform_ops?

        render json: { error: "Forbidden" }, status: :forbidden
      end
    end
  end
end
