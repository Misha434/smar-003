require 'rails_helper'

RSpec.describe Compare, type: :model do
  describe 'Data Validity' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @user = FactoryBot.create(:user)
      @compare = Compare.new(user_id: 1, product_id: 1)
    end
    it 'is working' do
      expect(@compare).to be_valid
    end
    it 'is not working without user_id' do
      compare = Compare.new(user_id: '', product_id: 1)
      expect(compare).to_not be_valid
    end
    it 'is not working without product_id' do
      compare = Compare.new(user_id: 1, product_id: '')
      expect(compare).to_not be_valid
    end
    it 'is not working duplicated data' do
      @compare.save!
      compare_duplicated = Compare.new(user_id: 1, product_id: 1)
      expect(compare_duplicated).to_not be_valid
    end
    it 'is not working invalid type data (user_id)' do
      compare_user_id_string = Compare.new(user_id: "あ", product_id: 1)
      expect(compare_user_id_string).to_not be_valid
    end
    it 'is not working invalid type data (product_id)' do
      compare_product_id_string = Compare.new(user_id: 1, product_id: "い")
      expect(compare_product_id_string).to_not be_valid
    end
  end
end
