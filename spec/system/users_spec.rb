require 'rails_helper'

RSpec.describe User, type: :system do
  
  describe 'Access Authenticate' do
    describe 'Users Index' do
      before do
        @brand = FactoryBot.create(:brand)
        @user = FactoryBot.create(:user)
        @product = FactoryBot.create(:product, brand_id: @brand.id)
        @review = FactoryBot.create(:review, user_id: @user.id, \
        product_id: @product.id)
        @admin_user = FactoryBot.create(:user, id: 2, name: "admin", email: "buzz@example.com", admin: true)
        visit root_path
      end
      describe 'as Admin User,' do
        before do
          within('header') do
            click_link "Login"
          end
          fill_in "Email", with: @admin_user.email
          fill_in "Password", with: @admin_user.password
          click_button "Log in"
        end
        it 'is unavailable to users/index' do
          visit '/users'
          expect(page).to have_content "All Users"
        end
      end
      describe 'as Normal Login User,' do
        before do
          within('header') do
            click_link "Login"
          end
          fill_in "Email", with: @user.email
          fill_in "Password", with: @user.password
          click_button "Log in"
        end
        it 'is unavailable to users/index' do
          visit '/users'
          expect(page).to have_content "Aaron"
        end
      end
      describe 'as Guest User,' do
        it 'is unavailable to users/index' do
          visit '/users'
          expect(page).to have_content "Log in"
        end
      end
    end
  end
end