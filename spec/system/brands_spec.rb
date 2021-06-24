require 'rails_helper'

RSpec.describe Brand, type: :system do
  
  def create_brand(i)
    i = i.to_i
    i.times do |n|
      name = "Brand-#{ n + 1 }"
      Brand.create!(
        id: n + 1,
        name: name
      )
    end
  end
  def create_product(i)
    i = i.to_i
    i.times do |n|
      name = "Phone-#{ n + 1 }"
      soc_antutu_score = 100
      battery_capacity = ( n + 1 ) * 1000
      brand_id = 1
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
  # Modify format Start 
  describe 'As Admin User,' do
    before do
      @brand = FactoryBot.build(:brand)
      @product = FactoryBot.build(:product)
      @admin_user = FactoryBot.create(:user, admin: true)
      visit root_path
      within('header') do
        click_on "Login"
      end
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @admin_user.password
      click_button "Log in"
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
            visit current_path #reload
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
        click_on 'Brands'
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
          pending 'Write after adding edit link'
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
        click_on 'Brands'
        click_on 'Apple'
        visit current_path
      end
      describe 'each product' do
        it 'indicates correct name' do
          expect(page).to have_content('Apple')
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
    
    end
    describe 'Delete Action' do
    
    end
  end
  # Modify format End 
#   describe 'Brand Page'
#     describe 'Access Authenticate' do
#       describe 'as Pre-Login User,' do
#         it 'is validate brand index page' do
#           visit '/brands'
#           expect(page).to have_content('Brand')
#         end
#         it 'is not validate brand new page' do
#           visit '/brands/new'
#           expect(page).to have_content('Log in')
#         end
#       end
#       describe 'brand show' do
#         before do
#           @brand = FactoryBot.create(:brand)
#         end
#         it 'can access brand show page' do
#           visit '/brands/1'
#           expect(page).to have_content('Apple')
#         end
#       end
#       describe 'Edit page' do
#         before do
#           @brand = FactoryBot.create(:brand)
#         end
#         it 'cannot be accessable' do
#           visit '/brands/1/edit'
#           expect(page).to have_content('Login')
#         end
#       end
#       describe 'destroy' do
#         before do
#           @brand = FactoryBot.create(:brand)
#         end
#         it 'can access brand destroy page' do
#           page.driver.submit :delete, '/brands/1', {}
#           expect(page).to have_content('Login')
#         end
#       end

#       describe 'As a Normal Login User' do
#         before do
#           @brand = FactoryBot.create(:brand)
#           @user = FactoryBot.create(:user)
#           visit '/users/sign_in'
#           fill_in "Email", with: @user.email
#           fill_in "Password", with: @user.password
#           click_button "Log in"
#           expect(page).to have_content 'Signed in'
#         end
#         describe 'has Access Authenticate' do
#           it 'to access brand index page' do
#             visit '/brands'
#             expect(page).to have_content('Apple')
#           end
#           it 'not to access brand new page' do
#             visit '/brands/new'
#             expect(page).to have_content('Aaron')
#           end
#           it 'to access brand show page' do
#             visit '/brands/1'
#             expect(page).to have_content('Apple')
#           end

#           it 'not to access brand edit page' do
#             visit '/brands/1/edit'
#             expect(page).to have_content('Aaron')
#           end

#           it 'can access brand destroy page' do
#             page.driver.submit :delete, '/brands/1', {}
#             visit '/brands'
#             expect(page).to have_content('Apple')
#           end
#         end
#       end
#     end
# end

# describe 'As Admin User' do
#   before do
#     @brand = FactoryBot.create(:brand)
#     @admin_user = FactoryBot.create(:user,
#                                     id: 2,
#                                     name: 'Admin',
#                                     email: 'buzz@example.com',
#                                     admin: true)
#     visit '/users/sign_in'
#     fill_in "Email", with: @admin_user.email
#     fill_in "Password", with: @admin_user.password
#     click_button "Log in"
#     expect(page).to have_content 'Signed in'
#   end

#   describe 'has authentication'
#   it 'to access Index page' do
#     visit '/brands'
#     expect(page).to have_content('Brand')
#   end

#   it 'to access Show page' do
#     visit '/brands/1'
#     expect(page).to have_content('Apple')
#   end

#   it 'to access Edit page' do
#     visit '/brands/1/edit'
#     expect(page).to have_content('Edit')
#   end
# end

# describe 'has Title' do
#   before do
#     @brand = FactoryBot.create(:brand)
#   end
#   it "'All Brands' in index page" do
#     visit '/brands'
#     expect(page).to have_title('All Brands - SmaR')
#   end
#   it "'Apple' in show page" do
#     visit '/brands/1'
#     expect(page).to have_title('Apple - SmaR')
#   end
# end

# describe 'CRUD' do
#   describe 'As Admin User' do
#     before do
#       @brand = FactoryBot.create(:brand)
#       @admin_user = FactoryBot.create(:user,
#                                       id: 2,
#                                       name: 'Admin',
#                                       email: 'buzz@example.com',
#                                       admin: true)
#       visit '/users/sign_in'
#       fill_in "Email", with: @admin_user.email
#       fill_in "Password", with: @admin_user.password
#       click_button "Log in"
#       expect(page).to have_content 'Signed in'
#     end
#     it 'create a new brand with an brand logo image' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
#       click_button "Create a new brand"
#       expect(page).to have_content 'example-company-2'
#       expect(page).to have_css("img[src$='image_test_logo.png']")
#     end
#     it 'create a new brand without an brand logo image' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       click_button "Create a new brand"
#       expect(page).to have_content 'example-company-2'
#     end
#     it 'cannot create a new brand with a name field is blank' do
#       visit '/brands/new'
#       fill_in 'Name', with: ''
#       click_button "Create a new brand"
#       expect(page).to have_content 'Add a New Brand'
#       expect(page).to have_content "Name can't be blank"
#     end
#     it 'cannot create a new brand in name field filled only spaces' do
#       visit '/brands/new'
#       fill_in 'Name', with: '  '
#       click_button "Create a new brand"
#       expect(page).to have_content 'Add a New Brand'
#       expect(page).to have_content "Name can't be blank"
#     end

#     it 'can create a new brand with an image less than 6mb' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
#       click_button "Create a new brand"
#       expect(page).to have_content 'example-company-2'
#     end
#     it 'can create a new brand with an png' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
#       click_button "Create a new brand"
#       expect(page).to have_content 'example-company-2'
#     end
#     it 'can create a new brand with an gif' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
#       click_button "Create a new brand"
#       expect(page).to have_content 'example-company-2'
#     end

#     it 'cannot create a new brand with an svg' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
#       click_button "Create a new brand"
#       expect(page).to have_content 'Add a New Brand'
#     end
#     it 'cannot create a new brand with an image greater than 6mb' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
#       click_button "Create a new brand"
#       expect(page).to have_content 'Add a New Brand'
#     end
#     it 'cannot create a new brand with an bmp image' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
#       click_button "Create a new brand"
#       expect(page).to have_content 'Add a New Brand'
#     end
#     it 'cannot create a new brand with an psd image' do
#       visit '/brands/new'
#       fill_in 'Name', with: 'example-company-2'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
#       click_button "Create a new brand"
#       expect(page).to have_content 'Add a New Brand'
#     end

#     it 'edit the Name Apple to brand-0' do
#       visit '/brands/1/edit'
#       fill_in 'Name', with: 'brand-0'
#       click_button "Update Brand"
#       expect(page).to have_content 'brand-0'
#     end

#     it 'cannot edit a new brand with a name field is blank' do
#       visit '/brands/1/edit'
#       fill_in 'Name', with: ''
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit a New Brand'
#       expect(page).to have_content "Name can't be blank"
#     end
#     it 'cannot edit a new brand in name field filled only spaces' do
#       visit '/brands/1/edit'
#       fill_in 'Name', with: '  '
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit a New Brand'
#       expect(page).to have_content "Name can't be blank"
#     end

#     it 'edit brand with an brand logo image' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
#       click_button "Update Brand"
#       expect(page).to have_content 'Apple'
#       expect(page).to have_css("img[src$='image_test_logo.png']")
#     end
#     it 'edit brand without an brand logo image' do
#       visit '/brands/1/edit'
#       click_button "Update Brand"
#       expect(page).to have_content 'Apple'
#     end

#     it 'can edit brand with an image less than 6mb' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
#       click_button "Update Brand"
#       expect(page).to have_content 'Apple'
#       expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
#     end
#     it 'can edit brand with an png' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
#       click_button "Update Brand"
#       expect(page).to have_content 'Apple'
#       expect(page).to have_css("img[src$='image_test_3kb.png']")
#     end
#     it 'can edit brand with an gif' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
#       click_button "Update Brand"
#       expect(page).to have_content 'Apple'
#       expect(page).to have_css("img[src$='image_test_3kb.gif']")
#     end

#     it 'cannot edit brand with an svg' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit a New Brand'
#     end
#     it 'cannot edit brand with an image greater than 6mb' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit a New Brand'
#     end
#     it 'cannot edit brand with an bmp image' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit a New Brand'
#     end
#     it 'cannot edit brand with an psd image' do
#       visit '/brands/1/edit'
#       attach_file "brand_image", \
#                   "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit a New Brand'
#     end

#     it 'fail to edit the Name with 51 charactors' do
#       visit '/brands/1/edit'
#       fill_in 'Name', with: 'a' * 51
#       click_button "Update Brand"
#       expect(page).to have_content 'Edit'
#     end

#     it 'delete brand' do
#       visit '/brands'
#       within "#brand-1" do
#         first(:css, ".delete_link").click
#       end
#       expect(page).to_not have_selector "#brand-1"
#     end
#   end
end
