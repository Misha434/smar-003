require 'rails_helper'

RSpec.describe Brand, type: :system do
  
  # Modify format Start 
  describe 'As Admin User,' do
    describe 'Create Action' do
      context 'filled in Name field' do
        it 'is available' do
          
        end
      end
      context 'filled in Name field and image' do
        it 'is available' do
          
        end
      end
      describe 'about Name field' do
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              
            end
          end
          # context '' do
          #   it 'is available' do
          
          #   end
          # end
          # context '' do
          #   it 'is unavailable' do
          
          #   end
          # end
        end
        describe 'charactor type' do
          context 'is 漢字・ひらがな・全角カタカナ' do
            it 'is available' do
              
            end
          end
          context 'is 半角カタカナ' do
            it 'is available' do
              
            end
          end
        end
        describe 'registrated' do
          it 'is available' do
          end
        end
      end
      describe 'about image field' do
        describe 'file format' do
          context 'jpeg' do
            it 'is available' do
            end
          end
          context 'png' do
            it 'is available' do
            end
          end
          context 'svg' do
            it 'is unavailable' do
            end
          end
          context 'gif' do
            it 'is unavailable' do
            end
          end
          context 'bmp' do
            it 'is unavailable' do
            end
          end
        end
        describe 'file size' do
          context '6MB' do
            it 'is available' do
            end
          end
          context 'over 6MB' do
            it 'is unavailable' do
            end
          end
        end
      end
      describe 'about image field(JS)' do
      end
    end
    describe 'Show Action' do
    
    end
    describe 'Update Action' do
    
    end
    describe 'Delete Action' do
    
    end
  end
  # Modify format End 
  describe 'Brand Page'
    describe 'Access Authenticate' do
      describe 'as Pre-Login User,' do
        it 'is validate brand index page' do
          visit '/brands'
          expect(page).to have_content('Brand')
        end
        it 'is not validate brand new page' do
          visit '/brands/new'
          expect(page).to have_content('Log in')
        end
      end
      describe 'brand show' do
        before do
          @brand = FactoryBot.create(:brand)
        end
        it 'can access brand show page' do
          visit '/brands/1'
          expect(page).to have_content('Apple')
        end
      end
      describe 'Edit page' do
        before do
          @brand = FactoryBot.create(:brand)
        end
        it 'cannot be accessable' do
          visit '/brands/1/edit'
          expect(page).to have_content('Login')
        end
      end
      describe 'destroy' do
        before do
          @brand = FactoryBot.create(:brand)
        end
        it 'can access brand destroy page' do
          page.driver.submit :delete, '/brands/1', {}
          expect(page).to have_content('Login')
        end
      end

      describe 'As a Normal Login User' do
        before do
          @brand = FactoryBot.create(:brand)
          @user = FactoryBot.create(:user)
          visit '/users/sign_in'
          fill_in "Email", with: @user.email
          fill_in "Password", with: @user.password
          click_button "Log in"
          expect(page).to have_content 'Signed in'
        end
        describe 'has Access Authenticate' do
          it 'to access brand index page' do
            visit '/brands'
            expect(page).to have_content('Apple')
          end
          it 'not to access brand new page' do
            visit '/brands/new'
            expect(page).to have_content('Aaron')
          end
          it 'to access brand show page' do
            visit '/brands/1'
            expect(page).to have_content('Apple')
          end

          it 'not to access brand edit page' do
            visit '/brands/1/edit'
            expect(page).to have_content('Aaron')
          end

          it 'can access brand destroy page' do
            page.driver.submit :delete, '/brands/1', {}
            visit '/brands'
            expect(page).to have_content('Apple')
          end
        end
      end
    end
end

describe 'As Admin User' do
  before do
    @brand = FactoryBot.create(:brand)
    @admin_user = FactoryBot.create(:user,
                                    id: 2,
                                    name: 'Admin',
                                    email: 'buzz@example.com',
                                    admin: true)
    visit '/users/sign_in'
    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: @admin_user.password
    click_button "Log in"
    expect(page).to have_content 'Signed in'
  end

  describe 'has authentication'
  it 'to access Index page' do
    visit '/brands'
    expect(page).to have_content('Brand')
  end

  it 'to access Show page' do
    visit '/brands/1'
    expect(page).to have_content('Apple')
  end

  it 'to access Edit page' do
    visit '/brands/1/edit'
    expect(page).to have_content('Edit')
  end
end

describe 'has Title' do
  before do
    @brand = FactoryBot.create(:brand)
  end
  it "'All Brands' in index page" do
    visit '/brands'
    expect(page).to have_title('All Brands - SmaR')
  end
  it "'Apple' in show page" do
    visit '/brands/1'
    expect(page).to have_title('Apple - SmaR')
  end
end

describe 'CRUD' do
  describe 'As Admin User' do
    before do
      @brand = FactoryBot.create(:brand)
      @admin_user = FactoryBot.create(:user,
                                      id: 2,
                                      name: 'Admin',
                                      email: 'buzz@example.com',
                                      admin: true)
      visit '/users/sign_in'
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @admin_user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    it 'create a new brand with an brand logo image' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
      click_button "Create a new brand"
      expect(page).to have_content 'example-company-2'
      expect(page).to have_css("img[src$='image_test_logo.png']")
    end
    it 'create a new brand without an brand logo image' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      click_button "Create a new brand"
      expect(page).to have_content 'example-company-2'
    end
    it 'cannot create a new brand with a name field is blank' do
      visit '/brands/new'
      fill_in 'Name', with: ''
      click_button "Create a new brand"
      expect(page).to have_content 'Add a New Brand'
      expect(page).to have_content "Name can't be blank"
    end
    it 'cannot create a new brand in name field filled only spaces' do
      visit '/brands/new'
      fill_in 'Name', with: '  '
      click_button "Create a new brand"
      expect(page).to have_content 'Add a New Brand'
      expect(page).to have_content "Name can't be blank"
    end

    it 'can create a new brand with an image less than 6mb' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
      click_button "Create a new brand"
      expect(page).to have_content 'example-company-2'
    end
    it 'can create a new brand with an png' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
      click_button "Create a new brand"
      expect(page).to have_content 'example-company-2'
    end
    it 'can create a new brand with an gif' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
      click_button "Create a new brand"
      expect(page).to have_content 'example-company-2'
    end

    it 'cannot create a new brand with an svg' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
      click_button "Create a new brand"
      expect(page).to have_content 'Add a New Brand'
    end
    it 'cannot create a new brand with an image greater than 6mb' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
      click_button "Create a new brand"
      expect(page).to have_content 'Add a New Brand'
    end
    it 'cannot create a new brand with an bmp image' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
      click_button "Create a new brand"
      expect(page).to have_content 'Add a New Brand'
    end
    it 'cannot create a new brand with an psd image' do
      visit '/brands/new'
      fill_in 'Name', with: 'example-company-2'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
      click_button "Create a new brand"
      expect(page).to have_content 'Add a New Brand'
    end

    it 'edit the Name Apple to brand-0' do
      visit '/brands/1/edit'
      fill_in 'Name', with: 'brand-0'
      click_button "Update Brand"
      expect(page).to have_content 'brand-0'
    end

    it 'cannot edit a new brand with a name field is blank' do
      visit '/brands/1/edit'
      fill_in 'Name', with: ''
      click_button "Update Brand"
      expect(page).to have_content 'Edit a New Brand'
      expect(page).to have_content "Name can't be blank"
    end
    it 'cannot edit a new brand in name field filled only spaces' do
      visit '/brands/1/edit'
      fill_in 'Name', with: '  '
      click_button "Update Brand"
      expect(page).to have_content 'Edit a New Brand'
      expect(page).to have_content "Name can't be blank"
    end

    it 'edit brand with an brand logo image' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
      click_button "Update Brand"
      expect(page).to have_content 'Apple'
      expect(page).to have_css("img[src$='image_test_logo.png']")
    end
    it 'edit brand without an brand logo image' do
      visit '/brands/1/edit'
      click_button "Update Brand"
      expect(page).to have_content 'Apple'
    end

    it 'can edit brand with an image less than 6mb' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
      click_button "Update Brand"
      expect(page).to have_content 'Apple'
      expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
    end
    it 'can edit brand with an png' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
      click_button "Update Brand"
      expect(page).to have_content 'Apple'
      expect(page).to have_css("img[src$='image_test_3kb.png']")
    end
    it 'can edit brand with an gif' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
      click_button "Update Brand"
      expect(page).to have_content 'Apple'
      expect(page).to have_css("img[src$='image_test_3kb.gif']")
    end

    it 'cannot edit brand with an svg' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
      click_button "Update Brand"
      expect(page).to have_content 'Edit a New Brand'
    end
    it 'cannot edit brand with an image greater than 6mb' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
      click_button "Update Brand"
      expect(page).to have_content 'Edit a New Brand'
    end
    it 'cannot edit brand with an bmp image' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
      click_button "Update Brand"
      expect(page).to have_content 'Edit a New Brand'
    end
    it 'cannot edit brand with an psd image' do
      visit '/brands/1/edit'
      attach_file "brand_image", \
                  "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.psd"
      click_button "Update Brand"
      expect(page).to have_content 'Edit a New Brand'
    end

    it 'fail to edit the Name with 51 charactors' do
      visit '/brands/1/edit'
      fill_in 'Name', with: 'a' * 51
      click_button "Update Brand"
      expect(page).to have_content 'Edit'
    end

    it 'delete brand' do
      visit '/brands'
      within "#brand-1" do
        first(:css, ".delete_link").click
      end
      expect(page).to_not have_selector "#brand-1"
    end
  end
end
