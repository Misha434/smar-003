require 'rails_helper'

RSpec.describe User, type: :system do
  describe 'Signup Page:' do
    before do
      @brand = FactoryBot.create(:brand)
      @admin_user = FactoryBot.create(:user, name: "admin", admin: true)
      @general_user = FactoryBot.create(:user, id: 2, name: "general", email: 'test-1@example.com')
      @product_1 = FactoryBot.create(:product, id: 1, name: "Phone-1")
      @product_2 = FactoryBot.create(:product, id: 2, name: "Phone-2")
      @product_3 = FactoryBot.create(:product, id: 3, name: "Phone-3")
      @review_1 = FactoryBot.create(:review, id: 1, product_id: @product_1.id)
      @review_2 = FactoryBot.create(:review, id: 2, product_id: @product_2.id)
      @review_3 = FactoryBot.create(:review, id: 3, product_id: @product_3.id)
      visit root_path
    end
    describe 'As Admin User,' do
      describe 'Signup link' do
        before do
          within('header') do
            find(:css, "button.dropdown-toggle").click
            click_on "Login"
          end
          fill_in "Email", with: @admin_user.email
          fill_in "Password", with: @admin_user.password
          click_button "Log in"
        end
        it 'in header is invisible' do
          within('header') do
            expect(page).to_not have_content("Signup")
          end
        end
        it 'directly is not available, redirect to root_path' do
          visit '/users/sign_up'
          expect(page).to have_content("Battery")
        end
      end
      describe 'As General User,' do
        before do
          within('header') do
            click_link "Login"
          end
          fill_in "Email", with: @general_user.email
          fill_in "Password", with: @general_user.password
          click_button "Log in"
        end
        it 'in header is invisible' do
          within('header') do
            expect(page).to_not have_content("Signup")
          end
        end
        it 'directly is not available, redirect to root_path' do
          visit '/users/sign_up'
          expect(page).to have_content("Battery")
        end
      end
    end
    describe 'As Guest User(Not Login yet),' do
      before do
        within('header') do
          find(:css, "button.dropdown-toggle").click
          click_link "Signup"
        end
      end
      it 'Signup page is accessable' do
        expect(page).to have_content('Signup')
      end
      describe 'Signup action', js: true do
        before do
          fill_in_all_form
        end
        describe 'with all form filled in' do
          it 'is available' do
            click_button "Sign up"
            expect(page).to have_content 'Welcome'
          end
        end
      end
    end
  end
  private

  def fill_in_all_form
    fill_in "Name", with: 'Michael Smith'
    fill_in "Email", with: 'michael-m@example.com'
    fill_in "Password", with: 'password'
    fill_in "Password confirmation", with: 'password'
    find(:css, "#agreement").set(true)
  end
end
