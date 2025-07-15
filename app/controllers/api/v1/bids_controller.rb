# app/controllers/api/v1/bids_controller.rb
module Api
  module V1
    class BidsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
      before_action :set_invoice, only: %i[index create]
      before_action :set_bid,     only: %i[show update destroy accept reject]

      # GET /api/v1/invoices/:invoice_id/bids
      # GET /api/v1/bids
      def index
        bids =
          if params[:invoice_id]
            @invoice.bids
          elsif current_user.platform_ops?
            Bid.all
          else
            current_user.bids
          end

        render json: bids.includes(:financer, :invoice)
      end

      # GET /api/v1/invoices/:invoice_id/bids/:id
      def show
        render json: @bid
      end

      # POST /api/v1/invoices/:invoice_id/bids
      def create
        @bid = @invoice.bids.build(bid_params.merge(financer: current_user))
        save_and_render @bid, :created
      end

      # PATCH /api/v1/invoices/:invoice_id/bids/:id
      def update
        save_and_render @bid, :ok
      end

      # DELETE /api/v1/invoices/:invoice_id/bids/:id
      def destroy
        @bid.destroy
        head :no_content
      end

      # PATCH /api/v1/invoices/:invoice_id/bids/:id/accept
      # PATCH /api/v1/invoices/:invoice_id/bids/:id/reject
      def accept; update_status(:accepted); end
      def reject; update_status(:rejected); end

      private

      def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
      end

      def set_bid
        @bid = Bid.find(params[:id])
      end

      def bid_params
        params.require(:bid).permit(:amount, :expiry_date)
      end

      def save_and_render(record, status)
        if record.save
          render json: record, status: status
        else
          render json: { errors: record.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update_status(new_status)
        @bid.update!(status: new_status)
        render json: @bid
      end
    end
  end
end
