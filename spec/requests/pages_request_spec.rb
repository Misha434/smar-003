require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "#index" do
    before do
      get root_url
    end
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      expect(response).to be_successful
    end
    
    # 200レスポンスを返すこと
    it 'return a 200 responce' do
      expect(response).to have_http_status 200
    end
    
  end
end
