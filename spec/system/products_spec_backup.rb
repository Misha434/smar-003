require 'rails_helper'

RSpec.describe Product, type: :system do
  describe 'Product Page can access'
  describe 'as Pre-Login User' do
    describe 'Access Authenticate' do
      it 'cannot access product new page' do
        visit '/products/new'
        expect(page).to have_content('Log in')
      end
      describe 'product show' do
        before do
          @brand = FactoryBot.create(:brand)
          @product = FactoryBot.create(:product)
          @user = FactoryBot.create(:user)
        end
        it 'can access product show page' do
          visit '/products/1'
          expect(page).to have_content('Phone-1')
        end
      end
      describe 'edit' do
        before do
          @brand = FactoryBot.create(:brand)
          @product = FactoryBot.create(:product)
        end
        it 'cannot access product edit page' do
          visit '/products/1/edit'
          expect(page).to have_content('Login')
        end
      end
      describe 'destroy' do
        before do
          @brand = FactoryBot.create(:brand)
          @product = FactoryBot.create(:product)
          @user = FactoryBot.create(:user)
        end
        it 'cannot access product destroy page' do
          page.driver.submit :delete, '/products/1', {}
          expect(page).to have_content('Login')
          fill_in "Email", with: @user.email
          fill_in "Password", with: @user.password
          click_button "Log in"
          visit '/products/1'
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-1')
        end
      end
    end
  end

  describe 'As a Login User' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @user = FactoryBot.create(:user)
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    describe 'Access Authenticate' do
      it 'cannot access product new page' do
        visit '/products/new'
        expect(page).to have_content('Aaron')
      end
      describe 'product show' do
        it 'can access product show page' do
          visit '/products/1'
          expect(page).to have_content('Phone-1')
        end
      end
      describe 'edit' do
        it 'cannot access product edit page' do
          visit '/products/1/edit'
          expect(page).to have_content('Aaron')
        end
      end
      describe 'destroy' do
        it 'cannot access product destroy page' do
          page.driver.submit :delete, '/products/1', {}
          visit '/products/1'
          expect(page).to have_content('Apple')
          expect(page).to have_content('Phone-1')
        end
      end
    end
  end

  describe 'CRUD' do
    describe 'As Admin User' do
      before do
        @brand = FactoryBot.create(:brand)
        @product = FactoryBot.create(:product)
        @admin_user = FactoryBot.create(
          :user,
          id: 2,
          email: 'buzz@example.com',
          admin: true
        )
        visit '/users/sign_in'
        fill_in "Email", with: @admin_user.email
        fill_in "Password", with: @admin_user.password
        click_button "Log in"
        expect(page).to have_content 'Signed in'
      end
      it 'create a new product' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        click_button "Create New Product"
        expect(page).to have_content 'test-phone'
      end

      it 'create a new Product with a product image' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_product.jpeg"
        click_button "Create New Product"
        expect(page).to have_content 'test-phone'
        expect(page).to have_css("img[src$='image_test_product.jpeg']")
      end
      it 'create a new product without a product image' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        click_button "Create New Product"
        expect(page).to have_content 'test-phone'
      end

      it 'cannot create a new product with a name field is blank' do
        visit '/products/new'
        fill_in 'Name', with: ''
        click_button "Create New Product"
        expect(page).to have_content 'Add New Product'
        expect(page).to have_content "Name can't be blank"
      end
      it 'cannot create a new brand in name field filled only spaces' do
        visit '/products/new'
        fill_in 'Name', with: '  '
        click_button "Create New Product"
        expect(page).to have_content 'Add New Product'
        expect(page).to have_content "Name can't be blank"
      end

      it 'can create a new product with an image less than 6mb' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
        click_button "Create New Product"
        expect(page).to have_content 'test-phone'
      end
      it 'can create a new product with an png' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
        click_button "Create New Product"
        expect(page).to have_content 'test-phone'
      end
      it 'can create a new product with an gif' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
        click_button "Create New Product"
        expect(page).to have_content 'test-phone'
      end

      it 'cannot create a new product with an svg' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
        click_button "Create New Product"
        expect(page).to have_content 'Add New Product'
      end
      it 'cannot create a new product with an image greater than 6mb' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
        click_button "Create New Product"
        expect(page).to have_content 'Add New Product'
      end
      it 'cannot create a new product with an bmp image' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
        click_button "Create New Product"
        expect(page).to have_content 'Add New Product'
      end
      it 'cannot create a new product with a New Brand' do
        visit '/products/new'
        fill_in 'Name', with: 'test-phone'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
        click_button "Create New Product"
        expect(page).to have_content 'Add New Product'
      end

      it 'cannot edit product with a name field is blank' do
        visit '/products/1/edit'
        fill_in 'Name', with: ''
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: 2000
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
        expect(page).to have_content "Name can't be blank"
      end

      it 'cannot edit product with a antutu field is blank' do
        visit '/products/1/edit'
        fill_in 'Name', with: 'Phone-1'
        select "Apple"
        fill_in 'Soc antutu score', with: nil
        fill_in 'Battery capacity', with: 2000
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
        expect(page).to have_content "Soc antutu score can't be blank"
      end
      it 'cannot edit product with a battery field is blank' do
        visit '/products/1/edit'
        fill_in 'Name', with: 'Phone-1'
        select "Apple"
        fill_in 'Soc antutu score', with: 2000
        fill_in 'Battery capacity', with: nil
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
        expect(page).to have_content "Battery capacity can't be blank"
      end
      it 'cannot edit product with antutu, battery fields are blank' do
        visit '/products/1/edit'
        fill_in 'Name', with: 'Phone-1'
        select "Apple"
        fill_in 'Soc antutu score', with: nil
        fill_in 'Battery capacity', with: nil
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
        expect(page).to have_content "Soc antutu score can't be blank"
        expect(page).to have_content "Battery capacity can't be blank"
      end
      it 'cannot edit product with all fields are blank' do
        visit '/products/1/edit'
        fill_in 'Name', with: ''
        select "Apple"
        fill_in 'Soc antutu score', with: nil
        fill_in 'Battery capacity', with: nil
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
        expect(page).to have_content "Soc antutu score can't be blank"
        expect(page).to have_content "Battery capacity can't be blank"
        expect(page).to have_content "Name can't be blank"
      end

      it 'edit a Product with a product image' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_product.jpeg"
        click_button "Update Product"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_product.jpeg']")
      end
      it 'edit product without a product image' do
        visit '/products/1/edit'
        click_button "Update Product"
        expect(page).to have_content 'Phone-1'
      end

      it 'can edit product with an image less than 6mb' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
        click_button "Update Product"
        expect(page).to have_content 'Phone-1'
      end
      it 'can edit product with an png' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
        click_button "Update Product"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_3kb.png']")
      end
      it 'can edit product with an gif' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
        click_button "Update Product"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_3kb.gif']")
      end

      it 'cannot edit product with an svg' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
      end
      it 'cannot edit product with an image greater than 6mb' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
      end
      it 'cannot edit product with an bmp image' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
      end
      it 'cannot edit product with a New Brand' do
        visit '/products/1/edit'
        attach_file "product_image", \
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
        click_button "Update Product"
        expect(page).to have_content 'Edit Product'
      end

      it 'edit the Name Phone-1 to product-0' do
        visit '/products/1/edit'
        select "Apple"
        fill_in 'Name', with: 'product-0'
        click_button "Update Product"
        expect(page).to have_content 'product-0'
      end
      it 'show index product' do
        visit '/products'
      end
      it 'delete Phone-1' do
        visit '/products'
        within "li#1" do
          first(:css, ".delete_link").click
        end
        expect(page).to_not have_selector "li#1"
      end
      it 'fail to edit the Name to BLANKED' do
        visit '/products/1/edit'
        fill_in 'Name', with: ''
        click_on "Update Product"
        expect(page).to have_content 'Edit'
      end
      it 'fail to edit the Name with 51 charactors' do
        visit '/products/1/edit'
        fill_in 'Name', with: 'a' * 51
        click_on "Update Product"
        expect(page).to have_content 'Edit'
      end
      it 'delete product' do
        visit '/products'
        within "li#1" do
          first(:css, ".delete_link").click
        end
        expect(page).to_not have_selector "li#1"
      end
    end
  end
end
