# app/controllers/api/v1/invoices_controller.rb
module Api
  module V1
    class InvoicesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!

      before_action :set_buyer,     if: -> { params[:buyer_id].present? }
      before_action :set_programme, if: -> { params[:programme_id].present? }
      before_action :set_invoice,   only: %i[show update destroy]

      # ─────────────────────────────────────
      # GET /buyers/:buyer_id/invoices
      # GET /programmes/:programme_id/invoices
      # ─────────────────────────────────────
      def index
        @invoices =
          if @programme
            @programme.invoices.includes(:supplier)
          elsif @buyer
            Invoice
              .joins(:programme)
              .where(programmes: { buyer_id: @buyer.id })
              .includes(:supplier)
          else
            Invoice.all.includes(:supplier)
          end

        render json: @invoices.as_json(include: :supplier)
      end

      # ─────────────────────────────────────
      # POST (same two endpoints)
      # ─────────────────────────────────────
      def create
        container =  @programme ||
                     Programme.find(invoice_params[:programme_id])

        @invoice = container.invoices.new(invoice_params)

        if @invoice.save
          render json: @invoice, status: :created
        else
          render json: { errors: @invoice.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      # show / update / destroy unchanged
      def show    = render json: @invoice.as_json(include: :supplier)

      def update
        if @invoice.update(invoice_params)
          render json: @invoice
        else
          render json: { errors: @invoice.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @invoice.destroy
        head :no_content
      end

      # ─────────────────────────────────────
      private
      # ─────────────────────────────────────
      def set_buyer     = @buyer     = Buyer.find(params[:buyer_id])
      def set_programme = @programme = Programme.find(params[:programme_id])
      def set_invoice   = @invoice   = Invoice.find(params[:id])

      def invoice_params
        params.require(:invoice)
              .permit(:programme_id, :supplier_id, :amount, :status, :due_date)
      end
    end
  end
end
