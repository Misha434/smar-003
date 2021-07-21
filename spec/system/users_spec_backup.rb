require 'rails_helper'

RSpec.describe "PagesIndices", type: :system do
  it "works with all kinds of HTML elements" do
    visit root_path
    click_link "Sma-R"
    expect(page).to have_current_path root_path
    
    user = FactoryBot.create(:user)
    visit root_path
    within('header') do
      click_link "Login"
    end
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content 'Signed in'
    
    click_link "Log out"
    expect(page).to have_content 'Signed out'
  end
  
  it "has title 'SmaR'" do
    visit root_path
    expect(page).to have_title 'SmaR'
  end
  
  describe "As Guest User" do
    
    before do
      @brand = FactoryBot.create(:brand)
      @user = FactoryBot.create(:user)
      @product = FactoryBot.create(:product, brand_id: @brand.id)
      @review = FactoryBot.create(:review, user_id: @user.id, \
      product_id: @product.id)
      visit root_path
    end
    
    describe 'can access' do
      it "a root page" do  
        expect(page).to have_content 'Battery'
        expect(page).to have_content 'Login'
      end
      
      it "a Signin page" do 
        within('header') do
          click_link "Login"
        end
        expect(page).to have_content 'Log in'
      end
      
      it "a Signup page" do
        within('header') do
          click_link "Signup"
        end
        expect(page).to have_content 'Sign up'
      end
      
      it "a Brand index page" do
        click_link 'Brands'
        expect(page).to have_content 'ブランド'
      end
      
      it "a Brand show page" do
        visit '/brands/1'
        expect(page).to have_content 'Apple'
      end
      
      it "a Product show page" do
        visit '/products/1'
        expect(page).to have_content 'Apple'
        # レビューが投稿できているか確認
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Awesome'
      end
      
      it "/products on click after login" do
        click_on 'All Products'
        fill_in "Email", with: 'tEst@eXample.com'
        fill_in "Password", with: @user.password
        click_button "Log in"
        expect(page).to have_content 'Signed in'
        expect(page).to have_content 'Apple'
        expect(page).to have_content 'Awesome'
      end
    end
    
    describe "can't access" do
      it "au User index page" do
        visit '/users'
        expect(page).to have_content 'Log in'
      end
      
      it "/products on click" do
        click_on 'All Products'
        expect(page).to have_content 'Login'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
      end
      
      it "an indivisual User show page" do
        visit '/users/1'
        expect(page).to have_content 'Log in'
      end
      
      it "an indivisual User edit page" do
        visit '/users/edit'
        expect(page).to have_content 'Log in'
      end
      
      it "an indivisual User destroy page" do
        visit '/users/destroy'
        expect(page).to have_content 'Log in'
      end
    end
  end
  
  describe "As not Signed up User", js: true do
    
    before do
      visit root_path
      within('header') do
        find(:css, "button.dropdown-toggle").click
        click_link "Signup"
      end
    end
    
    it "work with SignUp under duplicated User Name" do
      fill_in "Name", with: 'example'
      fill_in "Email", with: 'example@example.com'
      fill_in "Password", with: 'password'
      fill_in "Password confirmation", with: 'password'
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content 'Welcome'
    end
    
    it "work with SignUp under duplicated User Name" do
      user = FactoryBot.create(:user)
      fill_in "Name", with: user.name
      fill_in "Email", with: 'foo@example.org'
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content 'Welcome'
    end
    
    it "don't work with SignUp under an empty Name form" do
      fill_in "Name", with: ""
      fill_in "Email", with: "john@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content "can't be blank"
    end

    
    it "don't work with SignUp under an empty Email form" do
      fill_in "Name", with: "John"
      fill_in "Email", with: ""
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content "can't be blank"
    end

    it "don't work with SignUp under an empty password form" do
      fill_in "Name", with: "John"
      fill_in "Email", with: "john@example.com"
      fill_in "Password", with: ""
      fill_in "Password confirmation", with: "password"
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content "can't be blank"
    end
    
    it "don't work with SignUp under an empty Password confirmation form" do
      fill_in "Name", with: "John"
      fill_in "Email", with: "john@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: ""
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content "can't be blank"
    end

    it "don't work with SignUp under an different word in Password and Password confirmation form" do
      fill_in "Name", with: "John"
      fill_in "Email", with: "john@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "foobarbuzz"
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content "doesn't match"
    end
    
    it "don't work with SignUp under duplicated Email User" do
      user = FactoryBot.create(:user)
      fill_in "Name", with: user.name
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content 'has already been taken'
    end
    
    it "don't work with SignUp under duplicated Email User (tEst)" do
      user = FactoryBot.create(:user)
      fill_in 'Name', with: user.name
      fill_in "Email", with: 'tEst@exAmple.com'
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      find(:css, "#agreement").set(true)
      click_button "Sign up"
  
      expect(page).to have_content 'has already been taken'
    end
  end
    
  describe "As Signed up User", js: false do
    before do
      @user = FactoryBot.create(:user)
      visit '/users/log_in'
    end
    
    it "works Login with a created User" do
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
  
      expect(page).to have_content 'Signed in'
    end
    
    it "doesn't work Login as a created User with nagative email" do
      fill_in "Email", with: "barbuzz@example.com"
      fill_in "Password", with: @user.password
      click_button "Log in"
  
      expect(page).to have_content 'Invalid Email or password.'
    end
    
    it "doesn't work Login as a created User with a nagative password" do
      fill_in "Email", with: @user.email
      fill_in "Password", with: 'hogehoge'
      click_button "Log in"
  
      expect(page).to have_content 'Invalid Email or password.'
    end
    
    it "work Login as a created User with a similer Email(tEst@eXample.com)" do
      fill_in "Email", with: 'tEst@eXample.com'
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
      click_link "Log out"
      # tEst@eXample.com が上書きされていないか確認
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    
    it "don't work Login as a created User with a nagative Password(pAssWord)" do
      fill_in "Email", with: @user.email
      fill_in "Password", with: 'pAssWord'
      click_button "Log in"
      expect(page).to have_content 'Invalid'
    end
  end
 
  describe "As User Aeron" do
    before do
      @user = FactoryBot.create(:user)
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
      first(:css, '.user_edit').click
    end
    
    it "work User Edit Page" do
      expect(page).to have_content 'Edit User'
    end
    
    it "work editing User name" do
      fill_in "Name", with: 'foobar'
      fill_in "Current password", with: @user.password
      
      click_button "Update"
  
      expect(page).to have_content "updated"
    end
    
    it "work editing User Email" do
      fill_in "Name", with: @user.name
      fill_in "Email", with: 'foo@example.org'
      fill_in "Current password", with: @user.password
      
      click_button "Update"
  
      expect(page).to have_content "updated"
    end
    
    it "work editing User Password" do
      fill_in "Password", with: 'barbuzz'
      fill_in "Password confirmation", with: 'barbuzz'
      fill_in "Current password", with: @user.password
      
      click_button "Update"
  
      expect(page).to have_content "updated"
    end
    
    it "work editing User Name, Email, Password at the same time" do
      fill_in "Name", with: 'foobar'
      fill_in "Email", with: 'foo@example.org'
      fill_in "Password", with: 'barbuzz'
      fill_in "Password confirmation", with: 'barbuzz'
      fill_in "Current password", with: @user.password
      
      click_button "Update"
  
      expect(page).to have_content "updated"
    end
    
    it "work editing User Name and Password at the same time" do
      fill_in "Name", with: 'foobar'
      fill_in "Password", with: 'barbuzz'
      fill_in "Password confirmation", with: 'barbuzz'
      fill_in "Current password", with: @user.password
      
      click_button "Update"
  
      expect(page).to have_content "updated"
    end
    
    it "work editing User Name and Email at the same time" do
      fill_in "Name", with: 'foobar'
      fill_in "Email", with: 'foo@example.org'
      fill_in "Current password", with: @user.password
      
      click_button "Update"
  
      expect(page).to have_content "updated"
    end
    
    it "don't work editing User with empty all forms" do
      fill_in "Name", with: ''
      fill_in "Email", with: ''
      fill_in "Password", with: ''
      fill_in "Password confirmation", with: ''
      fill_in "Current password", with: ''
      click_button "Update"
  
      expect(page).to have_content "can't be blank"
    end
    
    it "don't work editing User Name with an empty current password form" do
      fill_in "Name", with: 'foobar'
      fill_in "Current password", with: ''
      click_button "Update"
  
      expect(page).to have_content "can't be blank"
    end
    
    it "don't work editing User Email with an empty current password form" do
      fill_in "Email", with: 'foobar@example.org'
      fill_in "Current password", with: ''
      click_button "Update"
  
      expect(page).to have_content "can't be blank"
    end
    
    it "don't work editing User Password with an empty current password form" do
      fill_in "Password", with: 'hogehoge'
      fill_in "Current password", with: ''
      click_button "Update"
  
      expect(page).to have_content "can't be blank"
    end
    
    it "don't work editing User Name with an negative current password" do
      fill_in "Name", with: 'hogehoge'
      fill_in "Current password", with: 'nagativepass'
      click_button "Update"
  
      expect(page).to have_content "invalid"
    end
    
    it "don't work editing User Email with an negative current password" do
      fill_in "Email", with: 'foobar@example.org'
      fill_in "Current password", with: 'nagativepass'
      click_button "Update"
  
      expect(page).to have_content "invalid"
    end
    
    it "don't work editing User Password with an negative current password" do
      fill_in "Password", with: 'changepassword'
      fill_in "Password confirmation", with: 'changepassword'
      fill_in "Current password", with: 'nagativepass'
      click_button "Update"
  
      expect(page).to have_content "invalid"
    end
    
    it "don't work editing User Password with an negative password to confirmation" do
      fill_in "Password", with: 'changepassword'
      fill_in "Password confirmation", with: 'differentpassword'
      fill_in "Current password", with: @user.password
      click_button "Update"
  
      expect(page).to have_content "doesn't match"
    end
  end
  
  describe "As User Aeron after edit Email" do
    before do
      @user = FactoryBot.create(:user)
      # Login
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
      # User Edit
      first(:css, '.user_edit').click
      fill_in "Email", with: 'foo@example.org'
      fill_in "Current password", with: @user.password
      click_button "Update"
      expect(page).to have_content "updated"
      click_link "Log out"
      expect(page).to have_content 'Signed out'
    end
    
    it "work login with the changed Email" do
      visit '/users/sign_in'
      fill_in "Email", with: 'foo@example.org'
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    
    it "don't work login with a former Email" do
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Invalid Email or password'
    end
  end
  
  describe "As User Aeron after edit password" do
    before do
      @user = FactoryBot.create(:user)
      # Login
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
      # User Edit
      first(:css, '.user_edit').click
      fill_in "Password", with: 'changedpass'
      fill_in "Password confirmation", with: 'changedpass'
      fill_in "Current password", with: @user.password
      click_button "Update"
      expect(page).to have_content "updated"
      # Logout
      click_link "Log out"
      expect(page).to have_content 'Signed out'
    end
    
    it "work login with the changed Password" do
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: 'changedpass'
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    
    it "don't work login with a former Password" do
      visit '/users/sign_in'
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      expect(page).to have_content 'Invalid Email or password'
    end
  end
end
