# app/controllers/api/v1/suppliers_controller.rb
module Api
  module V1
    class SuppliersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
      before_action :ensure_platform_ops!, only: %i[index create update destroy]
      before_action :set_supplier,         only: %i[show update destroy]

      # ---------------------------------------------------------------------
      # CRUD
      # ---------------------------------------------------------------------

      # GET /api/v1/suppliers
      def index
        render json: Supplier.all
      end

      # GET /api/v1/suppliers/:id
      def show
        render json: @supplier,
               include: { invoices: { include: { programme: { include: :buyer } } } }
      end

      # POST /api/v1/suppliers
      #
      # Params (JSON):
      #   {
      #     supplier: {
      #       name:                 "Acme Ltd",
      #       contact_email:        "supplier@example.com",
      #       invite:               "create" | "invite",
      #       password:             "...",   # only when invite == "create"
      #       password_confirmation:"..."    # only when invite == "create"
      #     }
      #   }
      #
      def create
        data = create_supplier_params

        supplier = nil
        ActiveRecord::Base.transaction do
          user = onboard_user!(data)

          supplier = Supplier.new(
            name:  data[:name],
            email: data[:contact_email], # satisfies Supplier validations
            user:  user
          )
          supplier.save! # will raise → rolled back & rescued below
        end

        render json: supplier, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: Array(e.record&.errors&.full_messages).presence || [e.message] },
               status: :unprocessable_entity
      end

      # PATCH /api/v1/suppliers/:id
      def update
        if @supplier.update(update_supplier_params)
          render json: @supplier
        else
          render json: { errors: @supplier.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/suppliers/:id
      def destroy
        @supplier.destroy
        head :no_content
      end

      # ---------------------------------------------------------------------
      # private helpers
      # ---------------------------------------------------------------------
      private

      # find or invite / create the User that backs this supplier
      def onboard_user!(data)
        if data[:invite] == "invite"
          User.find_by(email: data[:contact_email]) ||
            User.invite!(email: data[:contact_email])
        else
          User.find_or_create_by!(email: data[:contact_email]) do |u|
            u.password              = data[:password]
            u.password_confirmation = data[:password_confirmation]
            u.role                  = :supplier_user
          end
        end
      end

      def set_supplier
        @supplier = Supplier.find(params[:id])
      end

      # strong params --------------------------------------------------------

      def create_supplier_params
        params.require(:supplier).permit(
          :name,
          :contact_email,
          :invite,                 # "create" | "invite"
          :password,
          :password_confirmation
        )
      end

      # only basic profile fields can be edited; passwords handled via Devise
      def update_supplier_params
        params.require(:supplier).permit(
          :name,
          :contact_email,
          :company
        )
      end

      # access control -------------------------------------------------------

      def ensure_platform_ops!
        return if current_user.platform_ops?

        render json: { error: "Forbidden" }, status: :forbidden
      end
    end
  end
end
