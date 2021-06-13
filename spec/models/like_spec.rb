require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Data Validity' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @user = FactoryBot.create(:user)
      @review = FactoryBot.create(:review)
    end
    it 'is working' do
      @like = Like.create(id: 1, user_id: 1, review_id: 1)
      expect(@like).to be_valid
    end
    it 'is not working without PK' do
      @like = Like.create(id: '', user_id: 1, review_id: 1)
      expect(@like).to_not be_valid
    end
    it 'is not working without user_id' do
      @like = Like.create(id: 1, user_id: '', review_id: 1)
      expect(@like).to_not be_valid
    end
    it 'is not working without review_id' do
      @like = Like.create(id: 1, user_id: 1, review_id: '')
      expect(@like).to_not be_valid
    end
  end
end
