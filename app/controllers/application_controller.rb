class ApplicationController < ActionController::API

    # bring in the cookies helper:
    include ActionController::Cookies
    # bring in protect_from_forgery and friends
    include ActionController::RequestForgeryProtection

    # For JSON/API controllers we don’t want the usual exception,
    # so use null_session (no flash, no redirect)
    protect_from_forgery with: :null_session
    
    
end
