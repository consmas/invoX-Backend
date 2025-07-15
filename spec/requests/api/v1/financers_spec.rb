require 'rails_helper'

RSpec.describe "Api::V1::Financers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/financers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/financers/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/financers/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/financers/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/v1/financers/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /portfolio" do
    it "returns http success" do
      get "/api/v1/financers/portfolio"
      expect(response).to have_http_status(:success)
    end
  end

end
