require 'rails_helper'

RSpec.describe Product, type: :system do
  def create_brand(brand_amount)
    brand_amount = brand_amount.to_i
    brand_amount.times do |n|
      name = "Brand-#{n + 1}"
      Brand.create!(
        id: n + 1,
        name: name
      )
    end
  end

  def create_product(product_amount)
    product_amount = product_amount.to_i
    product_amount.times do |n|
      id = n + 1
      name = "Phone-#{n + 1}"
      soc_antutu_score = 1_000_000 - 1000 * n
      battery_capacity = (n + 1) * 1000
      brand_id = 1
      release_date = DateTime.now - n
      image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
                                                     filename: "product-photo-#{n}.jpeg")
      Product.create!(
        id: id,
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        release_date: release_date,
        image: image
      )
    end
  end

  def fill_in_all_forms
    fill_in 'Name', with: @product.name
    select "Apple"
    fill_in 'Release date', with: @product.release_date
    fill_in 'Soc antutu score', with: @product.soc_antutu_score
    fill_in 'Battery capacity', with: @product.battery_capacity
  end
  before do
    @brand = FactoryBot.build(:brand)
    @product = FactoryBot.build(:product)
    visit root_path
  end
  # Modify format Start
  describe 'As Admin User,' do
    before do
      @admin_user = FactoryBot.create(:user, admin: true)
      within('header') do
        find(:css, "button.dropdown-toggle").click
        click_on "ログイン"
      end
      fill_in "Email", with: @admin_user.email
      fill_in "パスワード", with: @admin_user.password
      click_button "ログイン"
      expect(page).to have_content 'ログインしました。'
    end
    describe 'Create Action' do
      before do
        @brand.save!
        visit '/products/new'
      end
      context 'filled in All field' do
        it 'is available' do
          fill_in_all_forms
          click_button "Create New Product"
          expect(page).to have_content 'Phone-1'
          expect(page).to have_content 'Apple'
        end
      end
      context 'filled in All field and image' do
        it 'is available' do
          fill_in_all_forms
          attach_file "product_image",
                      "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
          click_button "Create New Product"
          expect(page).to have_content 'Phone-1'
          expect(page).to have_content 'Apple'
          expect(page).to have_css("img[src$='image_test_logo.png']")
        end
      end
      describe 'about Name field' do
        before do
          @brand.save!
          visit '/products/new'
        end
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              fill_in_all_forms
              fill_in 'Name', with: ''
              click_button "Create New Product"
              expect(page).to have_content 'Add New Product'
              expect(page).to have_content "Name が入力されていません。"
            end
          end
          context 'is 1' do
            it 'is available' do
              fill_in_all_forms
              fill_in 'Name', with: 'X'
              click_button "Create New Product"
              expect(page).to have_content 'X'
              expect(page).to have_content 'Apple'
            end
          end
          context 'is 50' do
            it 'is available' do
              testdata_product_name = 'Aaron and associates Example Company East Asia Inc'
              fill_in_all_forms
              fill_in 'Name', with: testdata_product_name
              click_button "Create New Product"
              expect(page).to have_content testdata_product_name
              expect(page).to have_content 'Apple'
            end
          end
          context 'is 51' do
            it 'is unavailable' do
              testdata_product_name = 'Philip and associates Example Company East Asia Inc'
              fill_in_all_forms
              fill_in 'Name', with: testdata_product_name
              click_button "Create New Product"
              expect(page).to have_content 'Add New Product'
              expect(page).to have_content "Name が長すぎます。"
            end
          end
        end
        describe 'charactor type' do
          context 'is 漢字・ひらがな・全角カタカナ' do
            it 'is available' do
              testdata_product_name = '株式会社東アジア・フィリップ・スミス・アンド・すずきたろう・アンド・さとうじろう・アソシエイツインク'
              fill_in_all_forms
              fill_in 'Name', with: testdata_product_name
              click_button "Create New Product"
              expect(page).to have_content testdata_product_name
              expect(page).to have_content 'Apple'
            end
          end
          context 'is 半角カタカナ' do
            it 'is available' do
              testdata_product_name = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ'
              fill_in_all_forms
              fill_in 'Name', with: testdata_product_name
              click_button "Create New Product"
              expect(page).to have_content testdata_product_name
              expect(page).to have_content 'Apple'
            end
          end
        end
        context "English(Upper/Down Case)" do
          it "is available" do
            testdata_product_name = "From fairest creatures we desire increase, That th"
            fill_in_all_forms
            fill_in 'Name', with: testdata_product_name
            click_button "Create New Product"
            expect(page).to have_content testdata_product_name
            expect(page).to have_content 'Apple'
          end
        end
        context "symbol" do
          it "is available" do
            testdata_product_name = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν"
            fill_in_all_forms
            fill_in 'Name', with: testdata_product_name
            click_button "Create New Product"
            expect(page).to have_content testdata_product_name
            expect(page).to have_content 'Apple'
          end
        end
        context "Number" do
          it "is available" do
            testdata_product_name = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583"
            fill_in_all_forms
            fill_in 'Name', with: testdata_product_name
            click_button "Create New Product"
            expect(page).to have_content testdata_product_name
            expect(page).to have_content 'Apple'
          end
        end
        context "Emoji" do
          it "is available" do
            testdata_product_name = "👨" * 50
            fill_in_all_forms
            fill_in 'Name', with: testdata_product_name
            click_button "Create New Product"
            expect(page).to have_content testdata_product_name
            expect(page).to have_content 'Apple'
          end
          it "is unavailable 51 charactors" do
            testdata_product_name = "👨" * 51
            fill_in_all_forms
            fill_in 'Name', with: testdata_product_name
            click_button "Create New Product"
            expect(page).to have_content 'Add New Product'
            expect(page).to have_content 'Apple'
          end
        end
        context "space" do
          it "only is unavailable" do
            fill_in_all_forms
            fill_in 'Name', with: ' 　'
            click_button "Create New Product"
            expect(page).to have_content 'Add New Product'
            expect(page).to have_content "Name が入力されていません。"
          end
        end
        describe 'registrated' do
          before do
            @product.save!
            visit current_path # reload
          end
          it 'as same brand is unavailable' do
            fill_in_all_forms
            fill_in 'Name', with: @product.name
            click_button "Create New Product"
            expect(page).to have_content 'Add New Product'
          end
        end
      end
      describe 'about image field' do
        before do
          fill_in_all_forms
        end
        describe 'file format' do
          context 'gif' do
            it 'is available' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
              click_button "Create New Product"
              expect(page).to have_content @product.name
              expect(page).to have_content 'Apple'
              expect(page).to have_css("img[src$='image_test_3kb.gif']")
            end
          end
          context 'jpeg' do
            it 'is available' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.jpeg"
              click_button "Create New Product"
              expect(page).to have_content @product.name
              expect(page).to have_content 'Apple'
              expect(page).to have_css("img[src$='image_test_3kb.jpeg']")
            end
          end
          context 'png' do
            it 'is available' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
              click_button "Create New Product"
              expect(page).to have_content @product.name
              expect(page).to have_content 'Apple'
              expect(page).to have_css("img[src$='image_test_3kb.png']")
            end
          end
          context 'svg' do
            it 'is unavailable' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
              click_button "Create New Product"
              expect(page).to have_content 'Add New Product'
            end
          end
          context 'bmp' do
            it 'is unavailable' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
              click_button "Create New Product"
              expect(page).to have_content 'Add New Product'
            end
          end
        end
        describe 'file size' do
          context 'less then 5MB' do
            it 'is available' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
              click_button "Create New Product"
              expect(page).to have_content 'Apple'
              expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
            end
          end
          context 'greater than 6MB' do
            it 'is unavailable' do
              attach_file "product_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
              click_button "Create New Product"
              expect(page).to have_content 'Add New Product'
              expect(page).to have_content 'Image should be less than 5MB'
            end
          end
        end
      end
    end
    describe 'Index Action' do
      before do
        @brand.save!
        click_on '製品一覧'
      end
      describe 'Search feature' do
        before do
          create_product(11)
          FactoryBot.create(:product, id: 12, name: "Test-12", battery_capacity: 90_000)
          visit current_path
        end
        describe "Searching" do
          context "form filled with blank" do
            before do
              click_on '検索'
            end
            it 'make result count collectly' do
              expect(page).to have_content('12件')
            end
            it 'show an available product link' do
              click_on 'Phone-1'
              expect(page).to have_content('Phone-1')
            end
            it 'show an available brand link' do
              within('#1') do
                click_on 'Apple'
              end
              expect(page).to have_content('Apple')
            end
            it 'pagination and link is available' do
              click_on 'Next'
              click_on 'Test-12'
              expect(page).to have_content('Test-12')
            end
            it 'can sort by battery capacity' do
              click_on 'バッテリー容量'
              within('#1') do
                expect(page).to have_content('Test-12')
                expect(page).to have_content('90000')
              end
              within('#2') do
                expect(page).to have_content('Phone-11')
                expect(page).to have_content('11000')
              end
            end
          end
          context "form filled with Phone" do
            before do
              fill_in '製品名', with: 'Phone'
              click_on '検索'
            end
            it 'make result count collectly' do
              expect(page).to have_content('11件')
            end
            it 'show an available product link' do
              click_on 'Phone-10'
              expect(page).to have_content('Phone-10')
            end
            it 'show an available brand link' do
              within('#10') do
                click_on 'Apple'
              end
              expect(page).to have_content('Apple')
            end
            it 'pagination and link is available' do
              click_on 'Next'
              click_on 'Phone-11'
              expect(page).to have_content('Phone-11')
            end
          end
          context "form filled with 'Test'" do
            before do
              fill_in '製品名', with: 'Test'
              click_on '検索'
            end
            it 'make result count collectly' do
              expect(page).to have_content('1件')
            end
            it 'show an available product link' do
              click_on 'Test-12'
              expect(page).to have_content('Test-12')
            end
            it 'show an available brand link' do
              click_on 'Apple'
              expect(page).to have_content('Apple')
            end
            it 'pagination and link is disable' do
              expect(page).to_not have_css('.page-item')
            end
          end
          context "form filled with Not exist 'Hello'" do
            before do
              fill_in '製品名', with: 'Hello'
              click_on '検索'
            end
            it 'show 該当商品 なし' do
              expect(page).to have_content('該当商品 なし')
            end
          end
        end
      end
      describe 'each product' do
        before do
          create_product(11)
          visit current_path
        end
        it 'link is available' do
          click_on 'Phone-1'
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-1')
        end
        it 'Edit link is available' do
          within('#1') do
            find(:css, '.edit_link').click
          end
          expect(page).to have_content('Edit Product')
        end
      end
      describe 'Pagination' do
        describe 'if brands exist equal to and less than 10' do
          before do
            create_product(10)
            visit current_path
          end
          it 'is disable' do
            expect(page).to have_content('Phone-1')
            expect(page).to have_content('Phone-5')
            expect(page).to have_content('Phone-10')
            expect(page).to_not have_css('.page-item')
          end
        end
        describe 'if brands exist greater than 10' do
          before do
            create_product(11)
            visit current_path
          end
          it 'is available' do
            expect(page).to have_content('Phone-1')
            expect(page).to have_content('Phone-5')
            expect(page).to have_content('Phone-10')
            expect(page).to have_css('.page-item')
            click_on 'Next'
            expect(page).to have_content('Phone-11')
            click_on 'Phone-11'
            expect(page).to have_content('Phone-11')
            expect(page).to have_content('Apple')
          end
        end
      end
      describe 'sort feature' do
        before do
          create_product(12)
          5.times do |n|
            FactoryBot.create(:user, id: n + 2, name: "general_user#{n}", email: "test-#{n}@example.jp")
          end
          FactoryBot.create(:review, id: 1, user_id: 1, product_id: 3, rate: 5)
          FactoryBot.create(:review, id: 2, user_id: 1, product_id: 2, rate: 5)
          FactoryBot.create(:review, id: 3, user_id: 2, product_id: 2, rate: 4)
          FactoryBot.create(:review, id: 4, user_id: 2, product_id: 1, rate: 4)
          visit current_path
        end
        it '(Antutu score) order is correct' do
          click_on 'Antutu'
          within('#1') do
            expect(page).to have_content('Phone-1')
            expect(page).to have_content('1000000')
          end
          within('#2') do
            expect(page).to have_content('Phone-2')
            expect(page).to have_content('999000')
          end
          within('#3') do
            expect(page).to have_content('Phone-3')
            expect(page).to have_content('998000')
          end
        end
        it '(Antutu score) product link is working' do
          click_on 'Antutu'
          within('#2') do
            click_on 'Phone-2'
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Awesome')
        end
        it '(Antutu score) brand link is working' do
          click_on 'Antutu'
          within('#3') do
            click_on 'Apple'
          end
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-12')
        end
        it '(Battery capacity) order is correct' do
          click_on 'バッテリー容量'
          within('#1') do
            expect(page).to have_content('Phone-12')
            expect(page).to have_content('12000 mAh')
          end
          within('#2') do
            expect(page).to have_content('Phone-11')
            expect(page).to have_content('11000 mAh')
          end
          within('#3') do
            expect(page).to have_content('Phone-10')
            expect(page).to have_content('10000 mAh')
          end
        end
        it '(Battery capacity) product link is working' do
          click_on 'バッテリー容量'
          within('#2') do
            click_on 'Phone-11'
          end
          expect(page).to have_content('Phone-11')
        end
        it '(Battery capacity) brand link is working' do
          click_on 'バッテリー容量'
          within('#3') do
            click_on 'Apple'
          end
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-10')
        end
        it '(Average Rate) order is correct' do
          click_on 'レビュー平均'
          within('#1') do
            expect(page).to have_content('Phone-3')
            expect(page).to have_content('5.0')
            expect(page).to have_selector('.active_star', count: 5)
            expect(page).to_not have_selector('.active_star_half')
            expect(page).to_not have_selector('.no_active_star')
          end
          within('#2') do
            expect(page).to have_content('Phone-2')
            expect(page).to have_content('4.5')
            expect(page).to have_selector('.active_star', count: 4)
            expect(page).to have_selector('.active_star_half', count: 1)
            expect(page).to_not have_selector('.no_active_star')
          end
          within('#3') do
            expect(page).to have_content('Phone-1')
            expect(page).to have_content('4.0')
            expect(page).to have_selector('.active_star', count: 4)
            expect(page).to_not have_selector('.active_star_half')
            expect(page).to have_selector('.no_active_star', count: 1)
          end
        end
        it '(Average Rate) product link is working' do
          click_on 'レビュー平均'
          within('#2') do
            click_on 'Phone-2'
          end
          expect(page).to have_content('Phone-2')
          expect(page).to have_content('Awesome')
        end
        it '(Average Rate) brand link is working' do
          click_on 'レビュー平均'
          within('#3') do
            click_on 'Apple'
          end
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-2')
        end
      end
    end
    describe 'Show Action' do
      before do
        @brand.save!
        @product.save!
        click_on '製品一覧'
        click_on 'Phone-1'
      end
      describe 'Product Title' do
        it 'indicates correct product name' do
          expect(page).to have_content('Phone-1')
        end
        it 'edits brand link is available' do
          within('.product_title') do
            find(:css, '.edit_link').click
          end
          expect(page).to have_content('Edit Product')
        end
      end
      describe 'each product' do
        it 'indicates correct product name' do
          within('.product_title') do
            expect(page).to have_content('Phone-1')
          end
        end
      end
      describe 'brand link' do
        it 'is available' do
          within('.brand_link') do
            click_on 'Apple'
          end
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-1')
        end
      end
      describe 'like count' do
        before do
          FactoryBot.create(:review)
          FactoryBot.create(:user, id: 2, name: 'Alice', email: 'test-1@example.com')
          within('.like_count')
        end
        context 'if 0 likes exist' do
          it 'is correct' do
            expect(page).to have_content('0')
          end
        end
        context 'if 1 like exist' do
          it 'is correct' do
            FactoryBot.create(:like, user_id: 1, review_id: 1)
            visit current_path
            expect(page).to have_content('1')
          end
        end
        context 'if 2 likes exist' do
          it 'is correct' do
            FactoryBot.create(:like, user_id: 1, review_id: 1)
            FactoryBot.create(:like, user_id: 2, review_id: 1)
            visit current_path
            expect(page).to have_content('2')
          end
        end
      end
      describe 'review count' do
        before do
          @review = FactoryBot.build(:review)
          within('.review_count')
        end
        context 'if 0 reviews exist' do
          it 'is correct' do
            expect(page).to have_content('0')
          end
        end
        context 'if 1 review exist' do
          it 'is correct' do
            @review.save!
            visit current_path
            expect(page).to have_content('1')
          end
        end
        context 'if 2 review exist' do
          it 'is correct' do
            @review.save!
            FactoryBot.create(:user, id: 2, email: 'test@example.org')
            FactoryBot.create(:review, id: 2, user_id: 2)
            visit current_path
            expect(page).to have_content('2')
          end
        end
      end
      describe 'Review Avg rate' do
        before do
          FactoryBot.create(:user, id: 2, email: 'test@example.org')
          FactoryBot.create(:user, id: 3, email: 'test@example.jp')
          FactoryBot.create(:user, id: 4, email: 'test-1@example.com')
          @review = FactoryBot.build(:review)
        end
        context 'if 0 reviews exist' do
          it 'indicate -' do
            expect(page).to have_content('-')
          end
        end
        context 'when 1 review has rate 1' do
          it 'indicate 1.0' do
            FactoryBot.create(:review, rate: 1)
            visit current_path
            within('.info_review_rate') do
              expect(page).to have_content('1.0')
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 4)
            end
          end
        end
        context 'when 1 review has rate 3' do
          it 'indicate 3.0' do
            @review.save!
            visit current_path
            within('.info_review_rate') do
              expect(page).to have_content('3.0')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 2)
            end
          end
        end
        context 'when 1 review has rate 5' do
          it 'indicate 5.0' do
            FactoryBot.create(:review, rate: 5)
            visit current_path
            within('.info_review_rate') do
              expect(page).to have_content('5.0')
              expect(page).to have_selector('.active_star', count: 5)
              expect(page).to_not have_selector('.active_star_half')
              expect(page).to_not have_selector('.no_active_star')
            end
          end
        end
        context 'when 2 reviews have rate 3, 4' do
          it 'indicate 3.5' do
            @review.save!
            FactoryBot.create(:review, id: 2, user_id: 2, rate: 4)
            visit current_path
            within('.info_review_rate') do
              expect(page).to have_content('3.5')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
          end
        end
        context 'when 3 reviews have rate 3, 4, 4' do
          it 'indicate 3.6' do
            @review.save!
            FactoryBot.create(:review, id: 2, user_id: 2, rate: 4)
            FactoryBot.create(:review, id: 3, user_id: 3, rate: 4)
            visit current_path
            within('.info_review_rate') do
              expect(page).to have_content('3.6')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
          end
        end
        context 'when 4 reviews have rate 3, 4, 4, 4' do
          it 'indicate 3.7' do
            @review.save!
            FactoryBot.create(:review, id: 2, user_id: 2, rate: 4)
            FactoryBot.create(:review, id: 3, user_id: 3, rate: 4)
            FactoryBot.create(:review, id: 4, user_id: 4, rate: 4)
            visit current_path
            within('.info_review_rate') do
              expect(page).to have_content('3.7')
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.active_star_half')
              expect(page).to have_selector('.no_active_star', count: 1)
            end
          end
        end
      end
      describe 'Antutu Value' do
        before do
          within('.value_antutu')
        end
        context 'is indicated correctly' do
          it 'is correct' do
            expect(page).to have_content('100')
          end
        end
      end
      describe 'Battery Value' do
        before do
          within('.value_battery')
        end
        context 'is indicated correctly' do
          it 'is correct' do
            expect(page).to have_content('1000')
          end
        end
      end
    end
    describe 'Update Action' do
      before do
        @brand.save!
        @product.save!
        click_on '製品一覧'
      end
      describe 'from products#index' do
        it 'is available' do
          within('#1') do
            find(:css, '.edit_link').click
          end
          fill_in 'Name', with: 'Phone-X'
          click_button "Update Product"
          expect(page).to have_content 'Phone-X'
        end
      end
      describe 'from products#show' do
        it 'is available' do
          click_on 'Phone-1'
          find(:css, '.edit_link').click
          fill_in 'Name', with: 'Phone-X'
          click_button "Update Product"
          expect(page).to have_content 'Phone-X'
        end
      end
      describe 'Edit form validation' do
        before do
          within('#1') do
            find(:css, '.edit_link').click
          end
        end
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              fill_in 'Name', with: ''
              click_button "Update Product"
              expect(page).to have_content 'Edit Product'
              expect(page).to have_content "Name が入力されていません。"
            end
          end
          context 'is 1' do
            it 'is available' do
              fill_in 'Name', with: 'X'
              click_button "Update Product"
              expect(page).to have_content 'X'
            end
          end
          context 'is 50' do
            it 'is available' do
              testdata_product_name = 'Aaron and associates Example Company East Asia Inc'
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content testdata_product_name
            end
          end
          context 'is 51' do
            it 'is unavailable' do
              testdata_product_name = 'Philip and associates Example Company East Asia Inc'
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content 'Edit Product'
              expect(page).to have_content "Name が長すぎます。"
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_product_name = '株式会社東アジア・フィリップ・スミス・アンド・すずきたろう・アンド・さとうじろう・アソシエイツインク'
                fill_in 'Name', with: testdata_product_name
                click_button "Update Product"
                expect(page).to have_content testdata_product_name
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_product_name = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ'
                fill_in 'Name', with: testdata_product_name
                click_button "Update Product"
                expect(page).to have_content testdata_product_name
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_product_name = "From fairest creatures we desire increase, That th"
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content testdata_product_name
            end
          end
          context "symbol" do
            it "is available" do
              testdata_product_name = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν"
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content testdata_product_name
            end
          end
          context "Number" do
            it "is available" do
              testdata_product_name = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583"
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content testdata_product_name
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_product_name = "👨" * 50
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content testdata_product_name
            end
            it "is unavailable 51 charactors" do
              testdata_product_name = "👨" * 51
              fill_in 'Name', with: testdata_product_name
              click_button "Update Product"
              expect(page).to have_content 'Edit Product'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'Name', with: ' 　'
              expect(page).to have_content 'Edit Product'
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path # reload
            end
            it 'is unavailable' do
              fill_in 'Name', with: @brand.name
              expect(page).to have_content 'Edit Product'
            end
          end
          describe 'about image field' do
            before do
              @brand.save!
              visit current_path # reload
            end
            describe 'file format' do
              context 'gif' do
                it 'is available' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
                  click_button "Update Product"
                  expect(page).to have_content @brand.name
                  expect(page).to have_css("img[src$='image_test_3kb.gif']")
                end
              end
              context 'jpeg' do
                it 'is available' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.jpeg"
                  click_button "Update Product"
                  expect(page).to have_content @brand.name
                  expect(page).to have_css("img[src$='image_test_3kb.jpeg']")
                end
              end
              context 'png' do
                it 'is available' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
                  click_button "Update Product"
                  expect(page).to have_content @brand.name
                  expect(page).to have_css("img[src$='image_test_3kb.png']")
                end
              end
              context 'svg' do
                it 'is unavailable' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                  click_button "Update Product"
                  expect(page).to have_content 'Edit Product'
                end
              end
              context 'bmp' do
                it 'is unavailable' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                  click_button "Update Product"
                  expect(page).to have_content 'Edit Product'
                end
              end
            end
            describe 'file size' do
              context 'less then 5MB' do
                it 'is available' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
                  click_button "Update Product"
                  expect(page).to have_content 'Apple'
                  expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
                end
              end
              context 'greater than 6MB' do
                it 'is unavailable' do
                  attach_file "product_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
                  click_button "Update Product"
                  expect(page).to have_content 'Edit Product'
                  expect(page).to have_content 'Image should be less than 5MB'
                end
              end
            end
          end
        end
      end
    end
    describe 'Delete Action' do
      before do
        @brand.save!
        @product.save!
        FactoryBot.create(:review)
        FactoryBot.create(:like, user_id: 1, review_id: 1)
        within('header') do
          find(:css, "button.navbar-toggler").click
        end
        click_on 'ブランド一覧'
      end
      describe 'in brands#show' do
        it 'is available' do
          click_on 'Apple'
          within('#product-1') do
            find(:css, '.edit_link').click
          end
          expect(page).to have_content 'Edit Product'
          find(:css, '.delete_link').click
          expect(page).to have_content '製品一覧'
          expect(page).to_not have_content 'Phone-1'
        end
        describe 'works dependency' do
          before do
            expect(page).to have_content 'Apple'
            click_on 'Apple'
            within('#product-1') do
              find(:css, '.edit_link').click
            end
            find(:css, '.delete_link').click
          end
          it 'in products#index' do
            visit '/products'
            expect(page).to_not have_content 'Phone-1'
          end
          it 'in products#show' do
            visit '/products/1'
            expect(page).to have_content '製品一覧'
            expect(page).to have_content '入力した製品は存在しません'
          end
        end
      end
    end
  end
  describe 'As Registrated User,' do
    before do
      @registrated_user = FactoryBot.create(:user)
      within('header') do
        click_on "ログイン"
      end
      fill_in "Email", with: @registrated_user.email
      fill_in "パスワード", with: @registrated_user.password
      click_button "ログイン"
      expect(page).to have_content 'ログインしました。'
    end
    describe 'Create Action' do
      it 'is not available' do
        visit '/products/new'
        expect(page).to_not have_content 'Add New Product'
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Index Action' do
      before do
        click_on '製品一覧'
      end
      describe 'each products' do
        before do
          @brand.save!
          @product.save!
          visit current_path
        end
        it 'link is available' do
          click_on 'Phone-1'
          expect(page).to have_content('Phone-1')
        end
        it 'Edit link is not available' do
          expect(page).to_not have_css('.edit_link')
          visit '/products/1/edit'
          expect(page).to have_content('Access denied')
        end
      end
      describe 'Pagination' do
        describe 'if products exist equal to and less than 10' do
          before do
            @brand.save!
            create_product(10)
            visit current_path
          end
          it 'is disable' do
            expect(page).to have_content('Phone-1')
            expect(page).to have_content('Phone-5')
            expect(page).to have_content('Phone-10')
            expect(page).to_not have_css('.page-item')
          end
        end
        describe 'if brands exist greater than 10' do
          before do
            @brand.save!
            create_product(11)
            visit current_path
          end
          it 'is available' do
            expect(page).to have_content('Phone-1')
            expect(page).to have_content('Phone-5')
            expect(page).to have_content('Phone-10')
            expect(page).to have_css('.page-item')
            within('.page-item.next') do
              click_on 'Next'
            end
            expect(page).to have_content('Phone-11')
            click_on 'Phone-11'
            expect(page).to have_content('Phone-11')
          end
        end
      end
    end
    describe 'Show Action' do
      before do
        @brand.save!
        @product.save!
        click_on 'ブランド一覧'
        click_on 'Apple'
        visit current_path
      end
      describe 'Brand Title' do
        it 'indicates correct brand name' do
          expect(page).to have_content('Apple')
        end
        it 'edits brand link is not available' do
          expect(page).to_not have_css('.edit_link')
        end
      end
      describe 'each product' do
        it 'indicates correct name' do
          within('#product-1') do
            expect(page).to have_content('Phone-1')
          end
        end
      end
      describe 'product link' do
        it 'is available' do
          within('#product-1') do
            expect(page).to have_content('Phone-1')
          end
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-1')
        end
        it 'for editing product is not available' do
          expect(page).to_not have_css('.edit_link')
        end
      end
      describe 'review count' do
        before do
          within('#product-1') do
            expect(page).to have_content('Phone-1')
          end
        end
        context 'if 1 review exist' do
          it 'is correct' do
            FactoryBot.create(:review)
            visit current_path
            expect(page).to have_content('レビュー数: 1')
          end
        end
        context 'if 2 reviews exist' do
          it 'is correct' do
            FactoryBot.create(:user, id: 2, name: 'user2', email: "test-1@example.com")
            FactoryBot.create(:review)
            FactoryBot.create(:review, id: 2, user_id: 2)
            visit current_path
            within('#product-1') do
              expect(page).to have_content('レビュー数: 2')
            end
          end
        end
      end
    end
    describe 'Edit Action' do
      before do
        @brand.save!
      end
      it 'is not available' do
        visit '/brands/1/edit'
        expect(page).to_not have_content 'Edit Product'
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Delete Action' do
      before do
        @brand.save!
        @product.save!
      end
      it 'can access brand destroy page' do
        page.driver.submit :delete, '/products/1', {}
        expect(page).to have_content 'Access denied'
      end
    end
  end

  describe 'As Guest User,' do
    before do
      @registrated_user = FactoryBot.create(:user)
    end
    describe 'Create Action' do
      it 'is not available' do
        visit '/products/new'
        expect(page).to_not have_content 'Add New Product'
        expect(page).to have_content 'ログイン'
        fill_in "Email", with: @registrated_user.email
        fill_in "パスワード", with: @registrated_user.password
        click_button "ログイン"
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Index Action' do
      before do
        @brand.save!
        @product.save!
        click_on '製品一覧'
      end
      it 'requires Login' do
        expect(page).to have_content('ログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
      it 'is available after login' do
        fill_in "Email", with: @registrated_user.email
        fill_in "パスワード", with: @registrated_user.password
        click_button "ログイン"
        click_on "製品一覧"
        expect(page).to have_content "製品一覧"
        expect(page).to have_content "Phone-1"
      end
    end
    describe 'Show Action' do
      before do
        @brand.save!
        @product.save!
        click_on 'ブランド一覧'
        click_on 'Apple'
        click_on 'Phone-1'
      end
      describe 'Product Title' do
        before do
          FactoryBot.create(:review)
        end
        it 'indicates correct product name' do
          expect(page).to have_content('Phone-1')
        end
        it 'edits product link is not available' do
          expect(page).to_not have_css('.edit_link')
        end
      end
      describe 'each review' do
        before do
          FactoryBot.create(:review)
          visit current_path
        end
        it 'indicates correct user' do
          expect(page).to have_content('Aaron')
        end
      end
      describe 'user link' do
        before do
          FactoryBot.create(:review)
          visit current_path
        end
        it 'is available' do
          click_on 'Aaron'
          expect(page).to have_content('Aaron')
          expect(page).to have_content('Phone-1')
          expect(page).to have_content('Awesome')
        end
        it 'for editing product is not available' do
          expect(page).to_not have_css('.edit_link')
        end
      end
      describe 'review count' do
        before do
          within('review_count')
        end
        context 'if 0 reviews exist' do
          it 'is correct' do
            expect(page).to have_content('0')
          end
        end
        context 'if 1 review exist' do
          it 'is correct' do
            FactoryBot.create(:review)
            visit current_path
            expect(page).to have_content('1')
          end
        end
        context 'if 2 reviews exist' do
          it 'is correct' do
            FactoryBot.create(:user, id: 2, name: 'user2', email: "test-1@example.com")
            FactoryBot.create(:review)
            FactoryBot.create(:review, id: 2, user_id: 2)
            visit current_path
            expect(page).to have_content('2')
          end
        end
      end
    end
    describe 'Edit Action' do
      before do
        @brand.save!
      end
      it 'is not available' do
        visit '/brands/1/edit'
        expect(page).to have_content 'ログイン'
        fill_in "Email", with: @registrated_user.email
        fill_in "パスワード", with: @registrated_user.password
        click_button "ログイン"
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Delete Action' do
      before do
        @brand.save!
      end
      it 'can access brand destroy page' do
        page.driver.submit :delete, '/brands/1', {}
        expect(page).to have_content 'ログイン'
        fill_in "Email", with: @registrated_user.email
        fill_in "パスワード", with: @registrated_user.password
        click_button "ログイン"
        click_on "ブランド一覧"
        expect(page).to have_content 'Apple'
      end
    end
  end
end
