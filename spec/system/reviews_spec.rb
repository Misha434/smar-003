require 'rails_helper'

RSpec.describe Review, type: :system do
  
  def ensure_browser_size(width = 1280, height = 720)
    Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
  end

  describe 'Review Page can access'
    describe 'as Pre-Login User' do
      describe 'Access Authenticate' do
        it 'cannot access review new page' do
          visit '/reviews/new'
          expect(page).to have_content('Log in')
        end
        describe 'review show' do
          before do
            @brand = FactoryBot.create(:brand)
            @product = FactoryBot.create(:product)
            @user = FactoryBot.create(:user)
            @review = FactoryBot.create(:review)
          end
          it 'can access review show page' do
            visit '/products/1'
            expect(page).to have_content('Awesome')
          end
        end
        describe 'edit' do
          before do
            @brand = FactoryBot.create(:brand)
            @product = FactoryBot.create(:product)
            @user = FactoryBot.create(:user)
            @review = FactoryBot.create(:review)
          end
          it 'cannot access review edit page' do
            visit '/reviews/1/edit'
            expect(page).to have_content('Login')
          end
        end
        describe 'destroy' do
          before do
            @brand = FactoryBot.create(:brand)
            @product = FactoryBot.create(:product)
            @user = FactoryBot.create(:user)
            @review = FactoryBot.create(:review)
          end
          it 'cannot access review destroy page' do
            page.driver.submit :delete, '/reviews/1', {}
            expect(page).to have_content('Login')
          end
        end
      end
    end
    
    describe 'As Admin User' do
      before do
        @brand = FactoryBot.create(:brand)
        @product = FactoryBot.create(:product)
        @admin_user = FactoryBot.create(
                        :user,
                        id: 1,
                        email: 'buzz@example.com',
                        admin: true,
                      )
        @review = FactoryBot.create(:review)
        visit '/users/sign_in'
        fill_in "Email", with: @admin_user.email
        fill_in "Password", with: @admin_user.password
        click_button "Log in"
        expect(page).to have_content 'Signed in'
      end
      describe 'Access Authenticate' do
        it 'can access review new page' do
          visit '/reviews/new'
          expect(page).to have_content('Post Review')
        end
        describe 'show reviews in Product show page' do
          it 'can access review show page' do
            visit '/products/1'
            expect(page).to have_content('Awesome')
          end
        end
        describe 'edit' do
          it 'can access review edit page' do
            visit '/reviews/1/edit'
            expect(page).to have_content('Edit')
          end
        end
        describe 'destroy' do
          it 'can access review destroy page' do
            page.driver.submit :delete, '/reviews/1', {}
          end
        end
      end
    end
  
  describe 'As a Login User' do
    before do
      @brand = FactoryBot.create(:brand)
      @product = FactoryBot.create(:product)
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(
                        :user,
                        id: 2,
                        name: 'fizzy',
                        email: 'fizz@example.com',
                      )
      @review = FactoryBot.create(:review)
      @other_review = FactoryBot.create(
                          :review,
                          id: 2,
                          user_id: 2,
                          content: 'Epic'
                        )
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    describe 'Access Authenticate' do
      it 'can access review new page' do
        visit '/reviews/new'
        expect(page).to have_content('Post Review')
      end
      
      describe 'show reviews in Product show page' do
        it 'can access review show page' do
          visit '/products/1'
          expect(page).to have_content('Awesome')
        end
      end
      describe 'edit' do
        it 'can access review edit page' do
          visit '/reviews/1/edit'
          expect(page).to have_content('Edit Review')
        end
        it 'cannot access other user review' do
          visit '/reviews/2/edit'
          expect(page).to have_content('Aaron')
          expect(page).to have_selector(:css,'.user_edit')
        end
      end
      
      describe 'destroy' do
        it 'cannot access review destroy page' do
          page.driver.submit :delete, '/reviews/2', {}
          expect(page).to have_content('Aaron')
          expect(page).to have_content('Awesome')
        end
      end
    end
  end
  
  describe 'CRUD' do
    describe 'As a Login User' do
      before do
        @brand = FactoryBot.create(:brand)
        @product = FactoryBot.create(:product)
        @user = FactoryBot.create(:user)
        @review = FactoryBot.build(:review)
        visit '/users/sign_in'
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"
        expect(page).to have_content 'Signed in'
      end
      it 'create a new review in new page', js: true do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Aaron'
      end
      
      it 'cannot create a review with blanked content' do
        visit '/reviews/new'
        fill_in 'review[content]', with: ''
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Post Review'
        expect(page).to have_content "Content can't be blank"
      end
      
      it 'can create a review with 140 charactors' do
        visit '/reviews/new'
        fill_in 'review[content]', with: 'a'*140
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_content "#{'a'*140}"
      end
      it 'cannot create a review with 141 charactors' do
        visit '/reviews/new'
        fill_in 'review[content]', with: 'a'*141
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Post Review'
        expect(page).to have_content "too long"
      end
      
      it 'create a new review with a review image', js: true do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_product.jpeg"
        click_button "Post"
        expect(page).to have_content 'Awesome'
        expect(page).to have_css("img[src$='image_test_product.jpeg']")
      end
      it 'create a new review without a review image' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Awesome'
      end
      
      it 'can create a new review with an image less than 6mb' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
        click_button "Post"
        expect(page).to have_content 'Awesome'
      end
      it 'can create a new review with png' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
        click_button "Post"
        expect(page).to have_content 'Awesome'
      end
      it 'can create a new review with gif' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
        click_button "Post"
        expect(page).to have_content 'Awesome'
      end
      
      it 'cannot create a new review with an svg' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
        click_button "Post"
        expect(page).to have_content 'Post Review'
      end
      it 'cannot create a new review with an image greater than 6mb' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
        click_button "Post"
        expect(page).to have_content 'Post Review'
      end
      it 'cannot create a new review with an image greater than 6mb(JS)', js: true do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
          expect(page.driver.browser.switch_to.alert.text).to eq "Maximum file size is 5MB. Please choose a smaller file."
          page.driver.browser.switch_to.alert.dismiss
      end
      it 'cannot create a new review with an bmp image' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
        click_button "Post"
        expect(page).to have_content 'Post Review'
        expect(page).to have_content 'valid image format'
      end
      it 'cannot create a new review with an psd image' do
        visit '/reviews/new'
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
        click_button "Post"
        expect(page).to have_content 'Post Review'
        expect(page).to have_content 'valid image format'
      end
      
      it 'create a new review in Current User page', js: true do
        visit '/users/1'
        ensure_browser_size if Capybara.current_driver == :selenium_chrome_headless
        fill_in 'review[content]', with: @review.content
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Apple'
        expect(page).to have_content 'Phone-1'
        expect(page).to have_content 'Awesome'
      end
      
      it 'edit the Content Awesome to Great' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        fill_in 'review[content]', with: 'Epic'
        click_button "Edit"
        expect(page).to have_content 'Epic'
      end
      
      
      it 'can create a review with 140 charactors' do
        visit '/reviews/new'
        fill_in 'review[content]', with: 'a'*140
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_content "#{'a'*140}"
      end
      it 'cannot create a review with 141 charactors' do
        visit '/reviews/new'
        fill_in 'review[content]', with: 'a'*141
        select "Apple"
        select "Phone-1"
        click_button "Post"
        expect(page).to have_content 'Post Review'
        expect(page).to have_content "too long"
      end
      
      it 'cannot edit a review with blanked content' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        fill_in 'review[content]', with: ''
        click_button "Edit"
        expect(page).to have_content 'Edit Review'
        expect(page).to have_content "Content can't be blank"
      end
      
      it 'edit a review with a product image' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_product.jpeg"
        click_button "Edit"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_product.jpeg']")
      end
      it 'edit the review without a product image' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        click_button "Edit"
        expect(page).to have_content 'Phone-1'
      end
      
      it 'can edit the review with an image less than 6mb' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
        click_button "Edit"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
      end
      it 'can edit the review with an png' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
        click_button "Edit"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_3kb.png']")
      end
      it 'can edit the review with an gif' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
        click_button "Edit"
        expect(page).to have_content 'Phone-1'
        expect(page).to have_css("img[src$='image_test_3kb.gif']")
      end
      
      it 'cannot edit the review with an svg' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
        click_button "Edit"
        expect(page).to have_content 'Edit Review'
        expect(page).to_not have_css("img[src$='image/image_test_3kb.svg']")
      end
      it 'cannot edit the review with an image greater than 6mb' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
        click_button "Edit"
        expect(page).to have_content 'Edit Review'
        expect(page).to_not have_css("img[src$='image_test_6mb.jpeg']")
      end
      it 'cannot edit the review with an bmp image' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
        click_button "Edit"
        expect(page).to have_content 'Edit Review'
        expect(page).to_not have_css("img[src$='image_test_3kb.bmp']")
      end
      it 'cannot edit the review with a New Brand' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        attach_file "review_image",
                    "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
        click_button "Edit"
        expect(page).to have_content 'Edit Review'
        expect(page).to_not have_css("img[src$='image_test_3kb.psd']")
      end
      
      
      it 'delete Phone-1 in a product page' do
        @review = FactoryBot.create(:review)
        visit '/products/1'
        within 'li#review-1' do
          first('.delete_link').click
        end
        expect(page).to_not have_content 'Aaron'
      end
      it 'fail to edit the Content to BLANKED' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        fill_in 'review[content]', with: ""
        click_on "Edit"
        expect(page).to have_content 'Edit Review'
      end
      it 'fail to edit the Content with 141 charactors' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        fill_in 'review[content]', with: "a" * 141
        click_on "Edit"
        expect(page).to have_content 'Edit Review'
      end
      it 'delete review on Edit page' do
        @review = FactoryBot.create(:review)
        visit '/reviews/1/edit'
        click_button "Delete"
        expect(page).to_not have_selector "Phone-1"
      end
      it 'delete review on current User Page' do
        @review = FactoryBot.create(:review)
        visit '/users/1'
        within 'li#review-1' do
          first('.delete_link').click
        end
        expect(page).to_not have_selector "li#1"
      end
    end
  end
end
