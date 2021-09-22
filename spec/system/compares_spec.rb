require 'rails_helper'

RSpec.describe Compare, type: :system do
  describe 'As Login User' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @product_2 = FactoryBot.create(:product, id: 2, name: "Phone-2", soc_antutu_score: 2000, battery_capacity: 2000)
      @product_3 = FactoryBot.create(:product, id: 3, name: "Phone-3", soc_antutu_score: 3000, battery_capacity: 3000)
      @user = FactoryBot.create(:user)
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "パスワード", with: @user.password
      click_button "ログイン"
      visit '/products/1'
    end
    describe 'products' do
      describe '#show', js: true do
        it 'has an available bookmark lists (0 Products)' do
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("まだ登録されていません")
          end
        end
        it 'has an available bookmark button (1 Product)' do
          find('#compare-disable').click
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("Phone-1")
            expect(find('.compare--battery1')).to have_content("1000")
            expect(find('.compare--antutu1')).to have_content("1000")
            expect(find('.compare--battery2')).to have_content("-")
          end
        end
        it 'has an available bookmark button (2 Products)' do
          find('#compare-disable').click
          visit 'products/2'
          find('#compare-disable').click
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("Phone-1")
            expect(page).to have_content("Phone-2")
            expect(find('.compare--battery1')).to have_content("1000")
            expect(find('.compare--antutu1')).to have_content("1000")
            expect(find('.compare--battery2')).to have_content("2000")
            expect(find('.compare--antutu2')).to have_content("2000")
          end
        end
        it 'has not an available button to add bookmark (3 Products)' do
          find('#compare-disable').click
          visit 'products/2'
          find('#compare-disable').click
          visit 'products/3'
          find('#compare-disable').click
          expect(page).to have_content("2つ以上登録できません")
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("Phone-1")
            expect(page).to have_content("Phone-2")
            expect(find('.compare--battery1')).to have_content("1000")
            expect(find('.compare--antutu1')).to have_content("1000")
            expect(find('.compare--battery2')).to have_content("2000")
            expect(find('.compare--antutu2')).to have_content("2000")
          end
        end
        it 'has an available button to remove bookmark (1 Product)' do
          find('#compare-disable').click
          find('#release-compare-disable').click
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("まだ登録されていません")
          end
        end
      end
      describe '#show, in modal', js: true do
        it 'works delete and add bookmarks' do
          find('#compare-disable').click
          visit 'products/2'
          find('#compare-disable').click
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("Phone-2")
            expect(find('.compare--battery2')).to have_content("2000")
            expect(find('.compare--antutu2')).to have_content("2000")
            find('.compare--delete2').click
          end
          page.driver.browser.switch_to.alert.accept
          visit 'products/3'
          find('#compare-disable').click
          find('#bookmark--dropdown').click
          find('#bookmark--table--link').click
          within('.modal-content') do
            expect(page).to have_content("お気に入り一覧")
            expect(page).to have_content("Phone-1")
            expect(page).to have_content("Phone-3")
            expect(find('.compare--battery2')).to have_content("3000")
            expect(find('.compare--antutu2')).to have_content("3000")
            expect(find('.compare--battery1')).to have_content("1000")
            expect(find('.compare--antutu1')).to have_content("1000")
          end
        end
      end
    end
  end
end
