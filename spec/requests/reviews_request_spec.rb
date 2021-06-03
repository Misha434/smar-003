require 'rails_helper'

RSpec.describe "Reviews", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/reviews/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/reviews/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
