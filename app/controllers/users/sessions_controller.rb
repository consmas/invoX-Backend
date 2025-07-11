# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token, only: %i[create destroy]

  require 'jwt'

  # POST /users/sign_in
  def create
    super do |resource|
      # 1️⃣ The token Devise-JWT just created for you:
      raw = request.env['warden-jwt_auth.token']

      # 2️⃣ Decode → inject your extra claims → re-encode
      payload, = JWT.decode(
        raw,
        Rails.application.credentials.devise_jwt_secret_key,
        true,
        { algorithm: 'HS256' }
      )
      payload['role']  = resource.role
      payload['email'] = resource.email
      new_token = JWT.encode(
        payload,
        Rails.application.credentials.devise_jwt_secret_key,
        'HS256'
      )

      # 3️⃣ **Set it as a plain cookie** so your Next.js can read it
      cookies[:invoix_token] = {
        value:     new_token,
        httponly:  true,
        secure:    Rails.env.production?,
        same_site: :lax,
        expires:   1.year.from_now
      }
    end
  end

  # DELETE /users/sign_out
  def destroy
    super
  ensure
    cookies.delete(:invoix_token)
  end

  protected

  def respond_with(resource, _opts = {})
    render json: { user: { id: resource.id, email: resource.email, role: resource.role } }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
