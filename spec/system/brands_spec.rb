require 'rails_helper'

RSpec.describe Brand, type: :system do
  before do
    @brand = FactoryBot.build(:brand)
    @product = FactoryBot.build(:product)
    visit root_path
  end
  describe 'As Admin User,' do
    before do
      @admin_user = FactoryBot.create(:user, admin: true)
      within('header') do
        click_on "ログイン"
      end
      fill_in "Email", with: @admin_user.email
      fill_in "パスワード", with: @admin_user.password
      click_button "ログイン"
      expect(page).to have_content 'Signed in'
    end
    describe 'Create Action' do
      before do
        visit '/brands/new'
      end
      context 'filled in Name field' do
        it 'is available' do
          fill_in 'Name', with: @brand.name
          click_button "Create a new brand"
          expect(page).to have_content 'Apple'
        end
      end
      context 'filled in Name field and image' do
        it 'is available' do
          fill_in 'Name', with: @brand.name
          attach_file "brand_image",
                      "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
          click_button "Create a new brand"
          expect(page).to have_content 'Apple'
          expect(page).to have_css("img[src$='image_test_logo.png']")
        end
      end
      describe 'about Name field' do
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              fill_in 'Name', with: ''
              click_button "Create a new brand"
              expect(page).to have_content 'Add a New Brand'
              expect(page).to have_content "Name can't be blank"
            end
          end
          context 'is 1' do
            it 'is available' do
              fill_in 'Name', with: 'X'
              click_button "Create a new brand"
              expect(page).to have_content 'X'
            end
          end
          context 'is 50' do
            it 'is available' do
              testdata_brand_name = 'Aaron and associates Example Company East Asia Inc'
              fill_in 'Name', with: testdata_brand_name
              click_button "Create a new brand"
              expect(page).to have_content testdata_brand_name
            end
          end
          context 'is 51' do
            it 'is unavailable' do
              testdata_brand_name = 'Philip and associates Example Company East Asia Inc'
              fill_in 'Name', with: testdata_brand_name
              click_button "Create a new brand"
              expect(page).to have_content 'Add a New Brand'
              expect(page).to have_content "Name is too long"
            end
          end
        end
        describe 'charactor type' do
          context 'is 漢字・ひらがな・全角カタカナ' do
            it 'is available' do
              testdata_brand_name = '株式会社東アジア・フィリップ・スミス・アンド・すずきたろう・アンド・さとうじろう・アソシエイツインク'
              fill_in 'Name', with: testdata_brand_name
              click_button "Create a new brand"
              expect(page).to have_content testdata_brand_name
            end
          end
          context 'is 半角カタカナ' do
            it 'is available' do
              testdata_brand_name = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ'
              fill_in 'Name', with: testdata_brand_name
              click_button "Create a new brand"
              expect(page).to have_content testdata_brand_name
            end
          end
        end
        context "English(Upper/Down Case)" do
          it "is available" do
            testdata_brand_name = "From fairest creatures we desire increase, That th"
            fill_in 'Name', with: testdata_brand_name
            click_button "Create a new brand"
            expect(page).to have_content testdata_brand_name
          end
        end
        context "symbol" do
          it "is available" do
            testdata_brand_name = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν"
            fill_in 'Name', with: testdata_brand_name
            click_button "Create a new brand"
            expect(page).to have_content testdata_brand_name
          end
        end
        context "Number" do
          it "is available" do
            testdata_brand_name = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583"
            fill_in 'Name', with: testdata_brand_name
            click_button "Create a new brand"
            expect(page).to have_content testdata_brand_name
          end
        end
        context "Emoji" do
          it "is available" do
            testdata_brand_name = "👨" * 50
            fill_in 'Name', with: testdata_brand_name
            click_button "Create a new brand"
            expect(page).to have_content testdata_brand_name
          end
          it "is unavailable 51 charactors" do
            testdata_brand_name = "👨" * 51
            fill_in 'Name', with: testdata_brand_name
            click_button "Create a new brand"
            expect(page).to have_content 'Add a New Brand'
          end
        end
        context "space" do
          it "only is unavailable" do
            fill_in 'Name', with: ' 　'
            expect(page).to have_content 'Add a New Brand'
          end
        end
        describe 'registrated' do
          before do
            @brand.save!
            visit current_path # reload
          end
          it 'is unavailable' do
            fill_in 'Name', with: @brand.name
            expect(page).to have_content 'Add a New Brand'
          end
        end
      end
      describe 'about image field' do
        before do
          fill_in 'Name', with: @brand.name
        end
        describe 'file format' do
          context 'gif' do
            it 'is available' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
              click_button "Create a new brand"
              expect(page).to have_content @brand.name
              expect(page).to have_css("img[src$='image_test_3kb.gif']")
            end
          end
          context 'jpeg' do
            it 'is available' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.jpeg"
              click_button "Create a new brand"
              expect(page).to have_content @brand.name
              expect(page).to have_css("img[src$='image_test_3kb.jpeg']")
            end
          end
          context 'png' do
            it 'is available' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
              click_button "Create a new brand"
              expect(page).to have_content @brand.name
              expect(page).to have_css("img[src$='image_test_3kb.png']")
            end
          end
          context 'svg' do
            it 'is unavailable' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
              click_button "Create a new brand"
              expect(page).to have_content 'Add a New Brand'
            end
          end
          context 'bmp' do
            it 'is unavailable' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
              click_button "Create a new brand"
              expect(page).to have_content 'Add a New Brand'
            end
          end
        end
        describe 'file size' do
          context 'less then 5MB' do
            it 'is available' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
              click_button "Create a new brand"
              expect(page).to have_content 'Apple'
              expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
            end
          end
          context 'greater than 6MB' do
            it 'is unavailable' do
              attach_file "brand_image",
                          "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
              click_button "Create a new brand"
              expect(page).to have_content 'Add a New Brand'
              expect(page).to have_content 'Image should be less than 5MB'
            end
          end
        end
      end
    end
    describe 'Index Action' do
      before do
        click_on 'ブランド一覧'
      end
      describe 'each brand' do
        before do
          @brand.save!
          visit current_path
        end
        it 'link is available' do
          click_on 'Apple'
          expect(page).to have_content('Apple')
        end
        it 'Product count is correct(product no exist)' do
          expect(page).to have_content('0 Products')
        end
        it 'Product count is correct(1 product exist)' do
          FactoryBot.create(:product)
          visit current_path
          expect(page).to have_content('1 Product')
        end
        it 'Product count is correct(2 products exist)' do
          create_product(2)
          visit current_path
          expect(page).to have_content('2 Products')
        end
        it 'Edit link is available' do
          find(:css, '.edit_link').click
          expect(page).to have_content('Edit a New Brand')
        end
      end
      describe 'Pagination' do
        describe 'if brands exist equal to and less than 10' do
          before do
            create_brand(10)
            visit current_path
          end
          it 'is disable' do
            expect(page).to have_content('Brand-1')
            expect(page).to have_content('Brand-5')
            expect(page).to have_content('Brand-10')
            expect(page).to_not have_css('.page-item')
          end
        end
        describe 'if brands exist greater than 10' do
          before do
            create_brand(11)
            visit current_path
          end
          it 'is available' do
            expect(page).to have_content('Brand-1')
            expect(page).to have_content('Brand-5')
            expect(page).to have_content('Brand-10')
            expect(page).to have_css('.page-item')
            within('.page-item.next') do
              click_on 'Next'
            end
            expect(page).to have_content('Brand-11')
            click_on 'Brand-11'
            expect(page).to have_content('Brand-11')
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
        it 'edits brand link is available' do
          within('.brand_title') do
            find(:css, '.edit_link').click
          end
          expect(page).to have_content('Edit a New Brand')
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
        it 'for editing product is available' do
          within('#product-1') do
            find(:css, '.edit_link').click
          end
          expect(page).to have_content('Edit Product')
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
            expect(page).to have_content('1 review')
          end
        end
        context 'if 2 reviews exist' do
          it 'is correct' do
            FactoryBot.create(:user, id: 2, name: 'user2', email: "test-1@example.com")
            FactoryBot.create(:review)
            FactoryBot.create(:review, id: 2, user_id: 2)
            visit current_path
            within('#product-1') do
              expect(page).to have_content('2 reviews')
            end
          end
        end
      end
    end
    describe 'Update Action' do
      before do
        @brand.save!
        @product.save!
        click_on 'ブランド一覧'
      end
      describe 'from brands#index' do
        it 'is available' do
          within('#brand-1') do
            find(:css, '.edit_link').click
          end
          fill_in 'Name', with: 'Example Inc'
          click_button "Update Brand"
          expect(page).to have_content 'Example Inc'
        end
      end
      describe 'from brands#show' do
        it 'is available' do
          click_on 'Apple'
          within('.brand_title') do
            find(:css, '.edit_link').click
          end
          fill_in 'Name', with: 'Example Inc'
          click_button "Update Brand"
          expect(page).to have_content 'Example Inc'
        end
      end
      describe 'Edit form validation' do
        before do
          within('#brand-1') do
            find(:css, '.edit_link').click
          end
        end
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              fill_in 'Name', with: ''
              click_button "Update Brand"
              expect(page).to have_content 'Edit a New Brand'
              expect(page).to have_content "Name can't be blank"
            end
          end
          context 'is 1' do
            it 'is available' do
              fill_in 'Name', with: 'X'
              click_button "Update Brand"
              expect(page).to have_content 'X'
            end
          end
          context 'is 50' do
            it 'is available' do
              testdata_brand_name = 'Aaron and associates Example Company East Asia Inc'
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content testdata_brand_name
            end
          end
          context 'is 51' do
            it 'is unavailable' do
              testdata_brand_name = 'Philip and associates Example Company East Asia Inc'
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content 'Edit a New Brand'
              expect(page).to have_content "Name is too long"
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_brand_name = '株式会社東アジア・フィリップ・スミス・アンド・すずきたろう・アンド・さとうじろう・アソシエイツインク'
                fill_in 'Name', with: testdata_brand_name
                click_button "Update Brand"
                expect(page).to have_content testdata_brand_name
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_brand_name = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ'
                fill_in 'Name', with: testdata_brand_name
                click_button "Update Brand"
                expect(page).to have_content testdata_brand_name
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_brand_name = "From fairest creatures we desire increase, That th"
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content testdata_brand_name
            end
          end
          context "symbol" do
            it "is available" do
              testdata_brand_name = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν"
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content testdata_brand_name
            end
          end
          context "Number" do
            it "is available" do
              testdata_brand_name = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583"
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content testdata_brand_name
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_brand_name = "👨" * 50
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content testdata_brand_name
            end
            it "is unavailable 51 charactors" do
              testdata_brand_name = "👨" * 51
              fill_in 'Name', with: testdata_brand_name
              click_button "Update Brand"
              expect(page).to have_content 'Edit a New Brand'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'Name', with: ' 　'
              expect(page).to have_content 'Edit a New Brand'
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path # reload
            end
            it 'is unavailable' do
              fill_in 'Name', with: @brand.name
              expect(page).to have_content 'Edit a New Brand'
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
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
                  click_button "Update Brand"
                  expect(page).to have_content @brand.name
                  expect(page).to have_css("img[src$='image_test_3kb.gif']")
                end
              end
              context 'jpeg' do
                it 'is available' do
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.jpeg"
                  click_button "Update Brand"
                  expect(page).to have_content @brand.name
                  expect(page).to have_css("img[src$='image_test_3kb.jpeg']")
                end
              end
              context 'png' do
                it 'is available' do
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
                  click_button "Update Brand"
                  expect(page).to have_content @brand.name
                  expect(page).to have_css("img[src$='image_test_3kb.png']")
                end
              end
              context 'svg' do
                it 'is unavailable' do
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                  click_button "Update Brand"
                  expect(page).to have_content 'Edit a New Brand'
                end
              end
              context 'bmp' do
                it 'is unavailable' do
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                  click_button "Update Brand"
                  expect(page).to have_content 'Edit a New Brand'
                end
              end
            end
            describe 'file size' do
              context 'less then 5MB' do
                it 'is available' do
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
                  click_button "Update Brand"
                  expect(page).to have_content 'Apple'
                  expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
                end
              end
              context 'greater than 6MB' do
                it 'is unavailable' do
                  attach_file "brand_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
                  click_button "Update Brand"
                  expect(page).to have_content 'Edit a New Brand'
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
        click_on 'ブランド一覧'
        click_on 'Apple'
        within('.brand_title') do
          find(:css, '.edit_link').click
        end
      end
      describe 'in brands#edit' do
        it 'is available' do
          find(:css, '.delete_link').click
          expect(page).to_not have_content 'Edit a New Brand'
          expect(page).to have_content 'ブランド一覧'
          expect(page).to_not have_content 'Apple'
        end
        describe 'works dependency' do
          before do
            find(:css, '.delete_link').click
          end
          it 'in products#index' do
            expect(page).to have_content 'ブランド一覧'
            expect(page).to_not have_content 'Apple'
            click_on 'ブランド一覧'
            expect(page).to_not have_content 'Phone-1'
          end
          it 'in users#show' do
            click_on 'プロフィール'
            expect(page).to_not have_content 'Phone-1'
            within('.like_count') do
              expect(page).to have_content '0'
            end
            within('.review_count') do
              expect(page).to have_content '0'
            end
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
      expect(page).to have_content 'Signed in'
    end
    describe 'Create Action' do
      it 'is not available' do
        visit '/brands/new'
        expect(page).to_not have_content 'Add a New Brand'
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Index Action' do
      before do
        click_on 'ブランド一覧'
      end
      describe 'each brand' do
        before do
          @brand.save!
          visit current_path
        end
        it 'link is available' do
          click_on 'Apple'
          expect(page).to have_content('Apple')
        end
        it 'Product count is correct(product no exist)' do
          expect(page).to have_content('0 Products')
        end
        it 'Product count is correct(1 product exist)' do
          FactoryBot.create(:product)
          visit current_path
          expect(page).to have_content('1 Product')
        end
        it 'Product count is correct(2 products exist)' do
          create_product(2)
          visit current_path
          expect(page).to have_content('2 Products')
        end
        it 'Edit link is not available' do
          expect(page).to_not have_css('.edit_link')
        end
      end
      describe 'Pagination' do
        describe 'if brands exist equal to and less than 10' do
          before do
            create_brand(10)
            visit current_path
          end
          it 'is disable' do
            expect(page).to have_content('Brand-1')
            expect(page).to have_content('Brand-5')
            expect(page).to have_content('Brand-10')
            expect(page).to_not have_css('.page-item')
          end
        end
        describe 'if brands exist greater than 10' do
          before do
            create_brand(11)
            visit current_path
          end
          it 'is available' do
            expect(page).to have_content('Brand-1')
            expect(page).to have_content('Brand-5')
            expect(page).to have_content('Brand-10')
            expect(page).to have_css('.page-item')
            within('.page-item.next') do
              click_on 'Next'
            end
            expect(page).to have_content('Brand-11')
            click_on 'Brand-11'
            expect(page).to have_content('Brand-11')
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
            expect(page).to have_content('1 review')
          end
        end
        context 'if 2 reviews exist' do
          it 'is correct' do
            FactoryBot.create(:user, id: 2, name: 'user2', email: "test-1@example.com")
            FactoryBot.create(:review)
            FactoryBot.create(:review, id: 2, user_id: 2)
            visit current_path
            within('#product-1') do
              expect(page).to have_content('2 reviews')
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
        expect(page).to_not have_content 'Edit a New Brand'
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Delete Action' do
      before do
        @brand.save!
      end
      it 'can access brand destroy page' do
        page.driver.submit :delete, '/brands/1', {}
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
        visit '/brands/new'
        expect(page).to_not have_content 'Add a New Brand'
        expect(page).to have_content 'ログイン'
        fill_in "Email", with: @registrated_user.email
        fill_in "パスワード", with: @registrated_user.password
        click_button "ログイン"
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Index Action' do
      before do
        click_on 'ブランド一覧'
      end
      describe 'each brand' do
        before do
          @brand.save!
          visit current_path
        end
        it 'link is available' do
          click_on 'Apple'
          expect(page).to have_content('Apple')
        end
        it 'Product count is correct(product no exist)' do
          expect(page).to have_content('0 Products')
        end
        it 'Product count is correct(1 product exist)' do
          FactoryBot.create(:product)
          visit current_path
          expect(page).to have_content('1 Product')
        end
        it 'Product count is correct(2 products exist)' do
          create_product(2)
          visit current_path
          expect(page).to have_content('2 Products')
        end
        it 'Edit link is not available' do
          expect(page).to_not have_css('.edit_link')
        end
      end
      describe 'Pagination' do
        describe 'if brands exist equal to and less than 10' do
          before do
            create_brand(10)
            visit current_path
          end
          it 'is disable' do
            expect(page).to have_content('Brand-1')
            expect(page).to have_content('Brand-5')
            expect(page).to have_content('Brand-10')
            expect(page).to_not have_css('.page-item')
          end
        end
        describe 'if brands exist greater than 10' do
          before do
            create_brand(11)
            visit current_path
          end
          it 'is available' do
            expect(page).to have_content('Brand-1')
            expect(page).to have_content('Brand-5')
            expect(page).to have_content('Brand-10')
            expect(page).to have_css('.page-item')
            within('.page-item.next') do
              click_on 'Next'
            end
            expect(page).to have_content('Brand-11')
            click_on 'Brand-11'
            expect(page).to have_content('Brand-11')
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
            expect(page).to have_content('1 review')
          end
        end
        context 'if 2 reviews exist' do
          it 'is correct' do
            FactoryBot.create(:user, id: 2, name: 'user2', email: "test-1@example.com")
            FactoryBot.create(:review)
            FactoryBot.create(:review, id: 2, user_id: 2)
            visit current_path
            within('#product-1') do
              expect(page).to have_content('2 reviews')
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
      it 'is not available' do
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

  private

  def create_brand(i)
    i = i.to_i
    i.times do |n|
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
      name = "Phone-#{n + 1}"
      soc_antutu_score = 100
      battery_capacity = (n + 1) * 1000
      brand_id = 1
      release_date = DateTime.now
      image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
                                                     filename: "product-photo-#{n}.jpeg")
      Product.create!(
        name: name,
        soc_antutu_score: soc_antutu_score,
        battery_capacity: battery_capacity,
        brand_id: brand_id,
        release_date: release_date,
        image: image
      )
    end
  end
end
