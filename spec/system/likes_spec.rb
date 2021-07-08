require 'rails_helper'

RSpec.describe Like, type: :system do
  describe 'As Login User' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @product_2 = FactoryBot.create(:product, id: 2, name: "Phone-2")
      @product_3 = FactoryBot.create(:product, id: 3, name: "Phone-3")
      @user = FactoryBot.create(:user)
      @review = FactoryBot.create(:review)
      @review_2 = FactoryBot.create(:review, id: 2, product_id: 2)
      @review_3 = FactoryBot.create(:review, id: 3, product_id: 3)
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      visit '/products/1'
    end
    describe 'Product Page' do
      describe 'products/1', js: true do
        it 'has an available good button' do
          expect(page).to have_content("Phone-1")
          within 'span.each-like-countup' do
            expect(page).to have_content("0")
          end
          within '#review-1' do
            click_link '0'
          end
          within 'span.each-like-countup' do
            expect(page).to have_content("1")
          end
        end
      end
      describe 'reset good button', js: true do
        it 'is available' do
          within '#review-1' do
            click_link '0'
          end
          within '#review-1' do
            click_link '1'
          end
          within 'span.each-like-countup' do
            expect(page).to have_content("0")
          end
        end
      end
    end
  end
end
