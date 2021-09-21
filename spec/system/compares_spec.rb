require 'rails_helper'

RSpec.describe Compare, type: :system do
  describe 'As Login User' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @product_2 = FactoryBot.create(:product, id: 2, name: "Phone-2")
      @product_3 = FactoryBot.create(:product, id: 3, name: "Phone-3")
      @user = FactoryBot.create(:user)
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "パスワード", with: @user.password
      click_button "ログイン"
      visit '/products/1'
    end
    describe 'Product Page' do
      describe 'products/1'do
        it 'has an available bookmark lists' do
          find('#bookmark--dropdown').click
          click_on '登録一覧'
          within('#compare-table') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("まだ登録されていません")
          end
        end
        it 'has an available bookmark button' do
          find('#compare-disable').click
          find('#bookmark--dropdown').click
          click_on '登録一覧'
          within('#compare-table') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("Phone-1")
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
