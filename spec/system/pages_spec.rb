require 'rails_helper'

RSpec.describe "Pages", type: :system do
  def create_brand
    4.times do |n|
      name = "Brand-#{n + 1}"
      Brand.create!(
        id: n + 1,
        name: name
      )
    end
  end

  def create_product_sort_battery
    4.times do |n|
      name = "Phone-#{n + 1}"
      soc_antutu_score = 100
      battery_capacity = (n + 1) * 1000
      brand_id = n + 1
      release_date = DateTime.now
      image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
                                                     filename: "product-photo-#{n}.jpeg")
      Product.create!(
        id: n + 1,
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        release_date: release_date,
        image: image
      )
    end
  end

  def create_product_sort_antutu
    4.times do |n|
      name = "Phone-#{n + 1}"
      soc_antutu_score = (n + 1) * 100
      battery_capacity = 1000
      brand_id = n + 1
      release_date = DateTime.now
      image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
                                                     filename: "product-photo-#{n}.jpeg")
      Product.create!(
        id: n + 1,
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        release_date: release_date,
        image: image
      )
    end
  end

  def create_product_sort_new_release
    4.times do |n|
      name = "Phone-#{n + 1}"
      soc_antutu_score = 100
      battery_capacity = 1000
      brand_id = n + 1
      release_date = "2021-07-10".to_date - n
      image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
                                                     filename: "product-photo-#{n}.jpeg")
      Product.create!(
        id: n + 1,
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        release_date: release_date,
        image: image
      )
    end
  end

  def create_review(review_amount)
    review_amount = review_amount.to_i
    review_amount.times do |n|
      content = "review #{n + 1}"
      Review.create!(
        user_id: 1,
        product_id: n + 1,
        content: content,
        rate: 3
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
      click_on '続きを表示'
    end
    expect(page).to have_content('バッテリー容量')
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
      click_on '続きを表示'
    end
  end

  def check_product_ranking_new_release_correction
    within('.ranking_new_release') do
      within('#ranking-1') do
        expect(page).to have_content('Phone-1')
        expect(page).to have_content('2021/07/10')
      end
      within('#ranking-2') do
        expect(page).to have_content('Phone-2')
        expect(page).to have_content('2021/07/09')
      end
      within('#ranking-3') do
        expect(page).to have_content('Phone-3')
        expect(page).to have_content('2021/07/08')
      end
    end
  end

  def check_product_link_new_release
    within('.ranking_new_release') do
      click_on 'Phone-1'
    end
    expect(page).to have_content('Phone-1')
    expect(page).to have_content('Brand-1')
    visit root_path
    within('.ranking_new_release') do
      click_on 'Phone-2'
    end
    expect(page).to have_content('Phone-2')
    expect(page).to have_content('Brand-2')
    visit root_path
    within('.ranking_new_release') do
      click_on 'Phone-3'
    end
    expect(page).to have_content('Phone-3')
    expect(page).to have_content('Brand-3')
    visit root_path
    within('.ranking_new_release') do
      click_on '続きを表示'
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
        find(:css, "button.dropdown-toggle").click
        click_on "ログイン"
      end
      fill_in "Email", with: @admin_user.email
      fill_in "パスワード", with: @admin_user.password
      click_button "ログイン"
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
        expect(page).to have_content('バッテリー容量')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('新発売')
      end
      it "製品一覧(products#index) link is valid" do
        click_on "製品一覧"
        expect(page).to have_content('製品一覧')
      end
      it "ブランド一覧(brands#index) link is valid" do
        click_on "ブランド一覧"
        expect(page).to have_content('ブランド一覧')
      end
      it "Logout link is valid" do
        click_link "ログアウト"
        expect(page).to have_content('バッテリー容量')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('新発売')
        within('header') do
          expect(page).to have_content('ログイン')
          expect(page).to have_content('新規登録')
        end
      end
    end
    describe "Within Battery Ranking," do
      before do
        create_product_sort_battery
        create_review(3)
        visit current_path
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
        create_review(3)
        visit current_path
      end
      it "Rank is correct" do
        check_product_ranking_antutu_correction
      end
      it "Link is valid" do
        check_product_link_ranking_antutu
        expect(page).to have_content('Antutu')
      end
    end
    describe "Within New lerease Ranking," do
      before do
        create_product_sort_new_release
        create_review(3)
        visit current_path
      end
      it "Rank is correct" do
        check_product_ranking_new_release_correction
      end
      it "Link is valid" do
        check_product_link_new_release
        within('h2') do
          expect(page).to have_content('製品一覧')
        end
      end
    end
    describe "Within Rate Average Ranking," do
      before do
        FactoryBot.create(:product)
        2.times do |n|
          FactoryBot.create(:user, id: n + 2, email: "test-#{n + 2}@example.com")
          FactoryBot.create(:product, id: n + 2, name: "Phone-#{n + 2}")
        end
      end
      # Test Format: RateAvg ( EachReviewRate / Reviewer Amount )
      # eg (2 persons give rate 1.0): 1.0 ( 1 + 1 / 2 )
      context '5.0 ( 5 / 1 )' do
        before do
          FactoryBot.create(:review, rate: 5)
          FactoryBot.create(:review, id: 2, product_id: 2)
          FactoryBot.create(:review, id: 3, product_id: 3)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('5.0')
              expect(page).to have_selector('.active_star', count: 5)
              expect(page).to_not have_selector('.no_active_star')
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.no_active_star', count: 2)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.no_active_star', count: 2)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-2'
            end
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-3') do
              click_on 'Phone-3'
            end
          end
          expect(page).to have_content('Phone-3')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
          expect(page).to have_content('製品一覧')
        end
      end
      context '5.0 ( 5 + 5 / 2 )' do
        before do
          FactoryBot.create(:review, rate: 5)
          FactoryBot.create(:review, id: 2, rate: 5, user_id: 2)
          FactoryBot.create(:review, id: 3, product_id: 2)
          FactoryBot.create(:review, id: 4, product_id: 3)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('5.0')
              expect(page).to have_selector('.active_star', count: 5)
              expect(page).to_not have_selector('.no_active_star')
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.no_active_star', count: 2)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.no_active_star', count: 2)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-2'
            end
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-3') do
              click_on 'Phone-3'
            end
          end
          expect(page).to have_content('Phone-3')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
          expect(page).to have_content('製品一覧')
        end
      end
      context '4.5 ( 5 + 4 / 2 )' do
        before do
          FactoryBot.create(:review, rate: 5)
          FactoryBot.create(:review, id: 2, rate: 4, user_id: 2)
          FactoryBot.create(:review, id: 3, product_id: 2)
          FactoryBot.create(:review, id: 4, product_id: 3, rate: 4)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('4.5')
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to have_selector('.active_star_half', count: 1)
              expect(page).to_not have_selector('.no_active_star')
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('4.0')
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 2)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-3'
            end
          end
          expect(page).to have_content('Phone-3')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
        end
      end
      context '4.6 ( 5 + 5 + 4 / 3 )' do
        before do
          FactoryBot.create(:review, rate: 5)
          FactoryBot.create(:review, id: 2, rate: 5, user_id: 2)
          FactoryBot.create(:review, id: 3, rate: 4, user_id: 3)
          FactoryBot.create(:review, id: 4, product_id: 2)
          FactoryBot.create(:review, id: 5, product_id: 3, rate: 4)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('4.6')
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to have_selector('.active_star_half', count: 1)
              expect(page).to_not have_selector('.no_active_star')
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('4.0')
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 2)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-3'
            end
          end
          expect(page).to have_content('Phone-3')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
        end
      end
      context '4.3 ( 5 + 4 + 4 / 3 )' do
        before do
          FactoryBot.create(:review, rate: 5)
          FactoryBot.create(:review, id: 2, rate: 4, user_id: 2)
          FactoryBot.create(:review, id: 3, rate: 4, user_id: 3)
          FactoryBot.create(:review, id: 4, product_id: 2, rate: 4)
          FactoryBot.create(:review, id: 5, product_id: 3)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('4.3')
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('4.0')
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 2)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-2'
            end
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
        end
      end
      context '2.0 ( 2 / 1 )' do
        before do
          FactoryBot.create(:review, rate: 2)
          FactoryBot.create(:review, id: 2, product_id: 2, rate: 1)
          FactoryBot.create(:review, id: 3, product_id: 3, rate: 1)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('2.0')
              expect(page).to have_selector('.active_star', count: 2)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 3)
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('1.0')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('1.0')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-2'
            end
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
        end
      end
      context '1.6 ( 2 + 2 + 1 / 3 )' do
        before do
          FactoryBot.create(:review, rate: 1)
          FactoryBot.create(:review, id: 2, rate: 2, product_id: 2, user_id: 2)
          FactoryBot.create(:review, id: 3, rate: 2, product_id: 2, user_id: 3)
          FactoryBot.create(:review, id: 4, product_id: 2, rate: 1)
          FactoryBot.create(:review, id: 5, product_id: 3, rate: 1)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('1.6')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to have_selector('.active_star_half', count: 1)
              expect(page).to have_selector('.no_active_star', count: 3)
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('1.0')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('1.0')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-2'
            end
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
        end
      end
      context '1.3 ( 2 + 1 + 1 / 3 )' do
        before do
          FactoryBot.create(:review, rate: 3)
          FactoryBot.create(:review, id: 2, rate: 2, product_id: 2, user_id: 2)
          FactoryBot.create(:review, id: 3, rate: 1, product_id: 2, user_id: 3)
          FactoryBot.create(:review, id: 4, product_id: 2, rate: 1)
          FactoryBot.create(:review, id: 5, product_id: 3, rate: 1)
          visit current_path
        end
        it "Rank has correct rate, order and star" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              expect(page).to have_content('Phone-1')
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 2)
            end
            within('#ranking-2') do
              expect(page).to have_content('Phone-2')
              expect(page).to have_content('1.3')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
            within('#ranking-3') do
              expect(page).to have_content('Phone-3')
              expect(page).to have_content('1.0')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
          end
        end
        it "Link is valid" do
          within('.ranking_rate_average') do
            within('#ranking-1') do
              click_on 'Phone-1'
            end
          end
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            within('#ranking-2') do
              click_on 'Phone-2'
            end
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Brand-1')
          visit root_path
          within('.ranking_rate_average') do
            click_on '続きを表示'
          end
        end
      end
    end
  end

  describe "Visit the site as Registrated User," do
    before do
      @registrated_user = FactoryBot.create(:user)
      visit root_path
      within('header') do
        click_on "ログイン"
      end
      fill_in "Email", with: @registrated_user.email
      fill_in "パスワード", with: @registrated_user.password
      click_button "ログイン"
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
        expect(page).to have_content('バッテリー容量')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('新発売')
      end
      it "製品一覧(products#index) link is valid" do
        click_on "製品一覧"
        expect(page).to have_content('製品一覧')
      end
      it "ブランド一覧(brands#index) link is valid" do
        click_on "ブランド一覧"
        expect(page).to have_content('ブランド一覧')
      end
      it "Logout link is valid" do
        click_link "ログアウト"
        expect(page).to have_content('バッテリー容量')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('新発売')
        within('header') do
          expect(page).to have_content('ログイン')
          expect(page).to have_content('新規登録')
        end
      end
    end
    describe "Within Battery Ranking," do
      before do
        create_product_sort_battery
        create_review(3)
        visit current_path
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
        create_review(3)
        visit current_path
      end
      it "Rank is correct" do
        check_product_ranking_antutu_correction
      end
      it "Link is valid" do
        check_product_link_ranking_antutu
        expect(page).to have_content('Antutu')
      end
    end
    describe "Within New release Ranking," do
      before do
        create_product_sort_new_release
        create_review(3)
        visit current_path
      end
      it "Rank is correct" do
        check_product_ranking_new_release_correction
      end
      it "Link is valid" do
        check_product_link_new_release
        within('h2') do
          expect(page).to have_content('製品一覧')
        end
      end
    end
  end
  describe "Guest(Trial) User" do
    before do
      FactoryBot.create(:user)
      visit root_path
    end
    it 'is available to log it in' do
      within('.ranking_battery') do
        click_on 'ゲストログイン'
      end
      expect(page).to have_content('Loged in as Guest User.')
    end
    it 'is available to log it out' do
      within('.ranking_battery') do
        click_on 'ゲストログイン'
      end
      within('header') do
        find(:css, ".dropdown-toggle").click
        click_on 'ログアウト'
      end
      expect(page).to have_content('Signed out successfully.')
    end
  end
  describe "Visit the site as Not-login User," do
    before do
      FactoryBot.create(:user)
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
        expect(page).to have_content('バッテリー容量')
        expect(page).to have_content('Antutu')
        expect(page).to have_content('新発売')
      end
      it "製品一覧(products#index) link require Login" do
        click_on "製品一覧"
        expect(page).to have_content('ログイン')
      end
      it "ブランド一覧(brands#index) link is valid" do
        click_on "ブランド一覧"
        expect(page).to have_content('ブランド一覧')
      end
      it "Login link is valid" do
        within('header') do
          click_link "ログイン"
        end
        expect(page).to have_content('ログイン')
      end
      it "Sign up link is valid" do
        within('header') do
          click_link "新規登録"
        end
        expect(page).to have_content('ログイン')
      end
    end
    describe "Battery Ranking" do
      before do
        create_product_sort_battery
        create_review(3)
        visit current_path
      end
      it "has Login and Signup links" do
        within('.ranking_battery') do
          expect(page).to have_content('ログインユーザー限定公開')
          click_on 'ログイン'
        end
        expect(page).to have_content('ログイン')
        click_on 'Sma-R'
        within('.ranking_battery') do
          click_on '新規登録'
        end
        expect(page).to have_content('新規登録')
      end
    end
    describe "Rate Avg Ranking" do
      before do
        create_product_sort_battery
        create_review(3)
        visit current_path
      end
      it "has Login and Signup links" do
        within('.rate_average') do
          expect(page).to have_content('ログインユーザー限定公開')
          click_on 'ログイン'
        end
        expect(page).to have_content('ログイン')
        click_on 'Sma-R'
        within('.rate_average') do
          click_on '新規登録'
        end
        expect(page).to have_content('新規登録')
      end
    end
    describe "Within Antutu Ranking," do
      before do
        create_product_sort_antutu
        create_review(3)
        visit current_path
      end
      it "Rank is correct" do
        check_product_ranking_antutu_correction
      end
      it "Link is valid" do
        check_product_link_ranking_antutu
        within('h2') do
          expect(page).to have_content('ログイン')
        end
      end
    end
    describe "Within New release Ranking," do
      before do
        create_product_sort_new_release
        create_review(3)
        visit current_path
      end
      it "Rank is correct" do
        check_product_ranking_new_release_correction
        expect(page).to have_content('製品一覧')
      end
      it "Link is valid" do
        check_product_link_new_release
        within('h2') do
          expect(page).to have_content('ログイン')
        end
      end
    end
  end
end
