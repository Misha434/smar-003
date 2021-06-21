require 'rails_helper'

RSpec.describe "Pages", type: :system do
  def create_brand
    4.times do |n|
      name = "Brand-#{ n + 1 }"
      Brand.create!(
        id: n + 1,
        name: name
      )
    end
  end
  def create_product_sort_battery
    4.times do |n|
      name = "Phone-#{ n + 1 }"
      soc_antutu_score = 100
      battery_capacity = ( n + 1 ) * 1000
      brand_id = n + 1
      image= ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
      filename: "product-photo-#{n}.jpeg")
      Product.create!(
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        image: image
      )
    end
  end
  def create_product_sort_antutu
    4.times do |n|
      name = "Phone-#{ n + 1 }"
      soc_antutu_score = ( n + 1 ) * 100
      battery_capacity = 1000
      brand_id = n + 1
      image= ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
      filename: "product-photo-#{n}.jpeg")
      Product.create!(
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        image: image
      )
    end
  end
  def check_product_ranking_battery_correction
    within('.ranking_battery') do
      within('#ranking-1') do
        expect(page).to have_content('Phone-4')
        expect(page).to have_content('4000 mAh')
      end
      within('#ranking-2') do
        expect(page).to have_content('Phone-3')
        expect(page).to have_content('3000 mAh')
      end
      within('#ranking-3') do
        expect(page).to have_content('Phone-2')
        expect(page).to have_content('2000 mAh')
      end
    end
  end
  def check_product_link_ranking_battery
    within('.ranking_battery') do
      click_on 'Phone-4'
    end
    expect(page).to have_content('Phone-4')
    expect(page).to have_content('Brand-4')
    visit root_path
    within('.ranking_battery') do
      click_on 'Phone-3'
    end
    expect(page).to have_content('Phone-3')
    expect(page).to have_content('Brand-3')
    visit root_path
    within('.ranking_battery') do
      click_on 'Phone-2'
    end
    expect(page).to have_content('Phone-2')
    expect(page).to have_content('Brand-2')
    visit root_path
    within('.ranking_battery') do
      click_on 'view more'
    end
    within('h2') do
      expect(page).to have_content('All Products')
    end
  end
  def check_product_ranking_antutu_correction
    within('.ranking_antutu') do
      within('#ranking-1') do
        expect(page).to have_content('Phone-4')
        expect(page).to have_content('400')
      end
      within('#ranking-2') do
        expect(page).to have_content('Phone-3')
        expect(page).to have_content('300')
      end
      within('#ranking-3') do
        expect(page).to have_content('Phone-2')
        expect(page).to have_content('200')
      end
    end
  end
  def check_product_link_ranking_antutu
    within('.ranking_antutu') do
      click_on 'Phone-4'
    end
    expect(page).to have_content('Phone-4')
    expect(page).to have_content('Brand-4')
    visit root_path
    within('.ranking_antutu') do
      click_on 'Phone-3'
    end
    expect(page).to have_content('Phone-3')
    expect(page).to have_content('Brand-3')
    visit root_path
    within('.ranking_antutu') do
      click_on 'Phone-2'
    end
    expect(page).to have_content('Phone-2')
    expect(page).to have_content('Brand-2')
    visit root_path
    within('.ranking_antutu') do
      click_on 'view more'
    end
    within('h2') do
      expect(page).to have_content('All Products')
    end
  end
  before do
    create_brand
  end
  describe "Signed in as Admin User," do
    before do
      @admin_user = FactoryBot.create(:user, admin: true)
      visit root_path
      within('header') do
        click_on "Login"
      end
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @admin_user.password
      click_button "Log in"
    end
    context "Title" do
      it "is correct" do
        expect(page).to have_title 'SmaR'
      end
    end
    context "Within Header," do
      it "Logo link is valid" do
        within('header') do
          click_on "Sma-R"
        end
        expect(page).to have_content('Battery')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('New release')
      end
      it "All Products(products#index) link is valid" do
        click_on "All Products"
        expect(page).to have_content('All Products')
      end
      it "Brands(brands#index) link is valid" do
        click_on "Brands"
        expect(page).to have_content('ブランド')
      end
      it "Logout link is valid" do
        click_link "Log out"
        expect(page).to have_content('Battery')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('New release')
        within('header') do
          expect(page).to have_content('Login')
          expect(page).to have_content('Signup')
        end
      end
    end
    describe "Within Battery Ranking," do
      before do
        create_product_sort_battery
        visit current_path # Reload Page
      end
      it "Rank is correct" do
        check_product_ranking_battery_correction
      end
      it "Link is valid" do
        check_product_link_ranking_battery
      end
    end
    describe "Within Antutu Ranking," do
      before do
        create_product_sort_antutu
        visit current_path # Reload Page
      end
      it "Rank is correct" do
        check_product_ranking_antutu_correction
      end
      it "Link is valid" do
        check_product_link_ranking_antutu
      end
    end
    describe "Within New lerease Ranking," do
      pending "Write after adding column lerease_year to products"
    end
  end

  describe "Visit the site as Registrated User," do
    before do
      @registrated_user = FactoryBot.create(:user)
      visit root_path
      within('header') do
        click_on "Login"
      end
      fill_in "Email", with: @registrated_user.email
      fill_in "Password", with: @registrated_user.password
      click_button "Log in"
    end
    context "Title" do
      it "is correct" do
        expect(page).to have_title 'SmaR'
      end
    end
    context "Within Header," do
      it "Logo link is valid" do
        within('header') do
          click_on "Sma-R"
        end
        expect(page).to have_content('Battery')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('New release')
      end
      it "All Products(products#index) link is valid" do
        click_on "All Products"
        expect(page).to have_content('All Products')
      end
      it "Brands(brands#index) link is valid" do
        click_on "Brands"
        expect(page).to have_content('ブランド')
      end
      it "Logout link is valid" do
        click_link "Log out"
        expect(page).to have_content('Battery')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('New release')
        within('header') do
          expect(page).to have_content('Login')
          expect(page).to have_content('Signup')
        end
      end
    end
    describe "Within Battery Ranking," do
      before do
        create_product_sort_battery
        visit current_path # Reload Page
      end
      it "Rank is correct" do
        check_product_ranking_battery_correction
      end
      it "Link is valid" do
        check_product_link_ranking_battery
      end
    end
    describe "Within Antutu Ranking," do
      before do
        create_product_sort_antutu
        visit current_path # Reload Page
      end
      it "Rank is correct" do
        check_product_ranking_antutu_correction
      end
      it "Link is valid" do
        check_product_link_ranking_antutu
      end
    end
    describe "Within New release Ranking," do
      pending "Write after adding column lerease_year to products"
    end
  end
  describe "Visit the site as Guest User," do
    before do
      visit root_path
    end
    context "Title" do
      it "is correct" do
        expect(page).to have_title 'SmaR'
      end
    end
    context "Within Header," do
      it "Logo link is valid" do
        within('header') do
          click_on "Sma-R"
        end
        expect(page).to have_content('Battery')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('New release')
      end
      it "All Products(products#index) link require Login" do
        click_on "All Products"
        expect(page).to have_content('Log in')
      end
      it "Brands(brands#index) link is valid" do
        click_on "Brands"
        expect(page).to have_content('ブランド')
      end
      it "Logout link is valid" do
        click_link "Log out"
        expect(page).to have_content('Battery')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('New release')
        within('header') do
          expect(page).to have_content('Login')
          expect(page).to have_content('Signup')
        end
      end
    end
    describe "Within Battery Ranking," do
      before do
        create_product_sort_battery
        visit current_path # Reload Page
      end
      it "Rank is correct" do
        check_product_ranking_battery_correction
      end
      it "Link is valid" do
        check_product_link_ranking_battery
      end
    end
    describe "Within Antutu Ranking," do
      before do
        create_product_sort_antutu
        visit current_path # Reload Page
      end
      it "Rank is correct" do
        check_product_ranking_antutu_correction
      end
      it "Link is valid" do
        check_product_link_ranking_antutu
      end
    end
    describe "Within New release Ranking," do
      pending "Write after adding column release_year to products"
    end
  end
end