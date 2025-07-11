require 'rails_helper'

RSpec.describe "Api::V1::Programmes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/programmes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/programmes/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/programmes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/programmes/update"
      expect(response).to have_http_status(:success)
    end
  end

end
