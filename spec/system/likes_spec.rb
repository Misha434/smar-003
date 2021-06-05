require 'rails_helper'

RSpec.describe Like, type: :system do
  
  describe 'As Login User' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @user = FactoryBot.create(:user)
      @review = FactoryBot.create(:review)
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
    end
    describe 'Product Page' do
      before do
        visit '/products/1'
      end
      describe 'products/1' do
        it 'has an available good button' do
          expect(page).to have_content("Phone-1")
          within first(:css,'span.each-like-countup') do
            expect(page).to have_content("0")
          end
          within '#review-1' do
            click_link '0'
          end
          within first(:css,'span.each-like-countup') do
            expect(page).to have_content("1")
          end
        end
        
        it 'has an available good button for delete good' do
          within '#review-1' do
            click_link '0'
          end
          within first(:css,'span.each-like-countup') do
            expect(page).to have_content("1")
          end
          within '#review-1' do
            click_link '1'
          end
          within first(:css,'span.each-like-countup') do
            expect(page).to have_content("0")
          end
        end
      end
    end
  end
end