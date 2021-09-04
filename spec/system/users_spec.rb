require 'rails_helper'

RSpec.describe User, type: :system do
  describe 'Signup Page:' do
    before do
      @brand = FactoryBot.create(:brand)
      @admin_user = FactoryBot.create(:user, name: "admin", admin: true)
      @general_user = FactoryBot.create(:user, id: 2, name: "general", email: 'test-1@example.com')
      @general_user2 = FactoryBot.build(:user, id: 3, name: "Michael Smith", email: 'michael-m@example.com')
      @product_1 = FactoryBot.create(:product, id: 1, name: "Phone-1")
      @product_2 = FactoryBot.create(:product, id: 2, name: "Phone-2")
      @product_3 = FactoryBot.create(:product, id: 3, name: "Phone-3")
      @review_1 = FactoryBot.create(:review, id: 1, product_id: @product_1.id)
      @review_2 = FactoryBot.create(:review, id: 2, product_id: @product_2.id)
      @review_3 = FactoryBot.create(:review, id: 3, product_id: @product_3.id)
      visit root_path
    end
    describe 'As Admin User,' do
      describe 'Signup link' do
        before do
          within('header') do
            find(:css, "button.dropdown-toggle").click
            click_on "ログイン"
          end
          fill_in "Email", with: @admin_user.email
          fill_in "パスワード", with: @admin_user.password
          click_button "ログイン"
        end
        it 'in header is invisible' do
          within('header') do
            expect(page).to_not have_content("新規登録")
          end
        end
        it 'directly is not available, redirect to root_path' do
          visit '/users/sign_up'
          expect(page).to have_content("バッテリー容量")
        end
      end
    end
    describe 'As General User,' do
      before do
        within('header') do
          click_link "ログイン"
        end
        fill_in "Email", with: @general_user.email
        fill_in "パスワード", with: @general_user.password
        click_button "ログイン"
      end
      it 'in header is invisible' do
        within('header') do
          expect(page).to_not have_content("新規登録")
        end
      end
      it 'directly is not available, redirect to root_path' do
        visit '/users/sign_up'
        expect(page).to have_content("バッテリー容量")
      end
    end
    describe 'As Guest User(Not Login yet),' do
      before do
        within('header') do
          find(:css, "button.dropdown-toggle").click
          click_link "新規登録"
        end
      end
      it 'Signup page is accessable' do
        expect(page).to have_content('新規登録')
      end
      describe 'Signup action', js: true do
        before do
          fill_in_all_form
        end
        describe 'with all form filled in' do
          it 'is available' do
            click_button "新規登録"
            expect(page).to have_content 'Welcome'
          end
          it '(with avatar image)is available' do
            attach_file "user_avatar",
                        "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
            click_button "新規登録"
            expect(page).to have_content 'Welcome'
          end
        end
        describe 'with Name form', js: true do
          describe 'of charactor count' do
            context 'is 0(zero)' do
              it 'is unavailable' do
                fill_in 'ユーザー', with: ''
                click_button "新規登録"
                expect(page).to have_content '新規登録'
                expect(page).to have_content "Name can't be blank"
              end
            end
            context 'is 1' do
              it 'is available' do
                fill_in 'ユーザー名', with: 'X'
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
              end
            end
            context 'is 50' do
              it 'is available' do
                testdata_name = 'Aaron and associates Example Company East Asia Inc'
                fill_in 'ユーザー名', with: testdata_name
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
              end
            end
            context 'is 51' do
              it 'is unavailable' do
                testdata_name = 'Philip and associates Example Company East Asia Inc'
                fill_in 'ユーザー名', with: testdata_name
                click_button "新規登録"
                expect(page).to have_content '新規登録'
                expect(page).to have_content "Name is too long"
              end
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_name = '株式会社東アジア・フィリップ・スミス・アンド・すずきたろう・アンド・さとうじろう・アソシエイツインク'
                fill_in 'ユーザー名', with: testdata_name
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_name = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ'
                fill_in 'ユーザー名', with: testdata_name
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_name = "From fairest creatures we desire increase, That th"
              fill_in 'ユーザー名', with: testdata_name
              click_button "新規登録"
              expect(page).to have_content 'Welcome'
            end
          end
          context "symbol" do
            it "is available" do
              testdata_name = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν"
              fill_in 'ユーザー名', with: testdata_name
              click_button "新規登録"
              expect(page).to have_content 'Welcome'
            end
          end
          context "Number" do
            it "is available" do
              testdata_name = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583"
              fill_in 'ユーザー名', with: testdata_name
              click_button "新規登録"
              expect(page).to have_content 'Welcome'
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_name = "👨" * 50
              fill_in 'ユーザー名', with: testdata_name
              click_button "新規登録"
              expect(page).to have_content 'Welcome'
            end
            it "is unavailable 51 charactors" do
              testdata_name = "👨" * 51
              fill_in 'ユーザー名', with: testdata_name
              click_button "新規登録"
              expect(page).to have_content '新規登録'
              expect(page).to have_content "Name is too long"
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'ユーザー名', with: ' 　'
              click_button "新規登録"
              expect(page).to have_content '新規登録'
            end
          end
          describe 'registrated' do
            it 'is available' do
              fill_in 'ユーザー名', with: @general_user.name
              fill_in 'Email', with: 'test-2@example.com'
              click_button "新規登録"
              expect(page).to have_content 'Welcome'
            end
          end
        end
        describe 'about image field', js: true do
          describe 'file format' do
            context 'gif' do
              it 'is available' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test.gif"
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
                within('header') do
                  find(:css, "button.dropdown-toggle").click
                  click_on 'プロフィール'
                end
                expect(page).to have_content @general_user2.name
                expect(page).to have_css("img[src$='image_test.gif']")
              end
            end
            context 'jpeg' do
              it 'is available' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
                within('header') do
                  find(:css, "button.dropdown-toggle").click
                  click_on 'プロフィール'
                end
                expect(page).to have_content @general_user2.name
                expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
              end
            end
            context 'png' do
              it 'is available' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test.png"
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
                within('header') do
                  find(:css, "button.dropdown-toggle").click
                  click_on 'プロフィール'
                end
                expect(page).to have_content @general_user2.name
                expect(page).to have_css("img[src$='image_test.png']")
              end
            end
            context 'svg' do
              it 'is unavailable' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                click_button "新規登録"
                expect(page).to have_content '新規登録'
              end
            end
            context 'bmp' do
              it 'is unavailable' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                click_button "新規登録"
                expect(page).to have_content '新規登録'
              end
            end
          end
          describe 'file size' do
            context 'less then 5MB' do
              it 'is available' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
                click_button "新規登録"
                expect(page).to have_content 'Welcome'
                within('header') do
                  find(:css, "button.dropdown-toggle").click
                  click_on 'プロフィール'
                end
                expect(page).to have_content @general_user2.name
                expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
              end
            end
            context 'greater than 6MB' do
              it 'is unavailable' do
                attach_file "user_avatar",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
                click_button "新規登録"
                expect(page).to have_content '新規登録'
                expect(page).to have_content 'Avatar should be less than 5MB'
              end
            end
          end
        end
      end
    end
  end

  describe 'Sign_in Page:' do
    before do
      @brand = FactoryBot.create(:brand)
      @admin_user = FactoryBot.create(:user, name: "admin", admin: true)
      @general_user = FactoryBot.create(:user, id: 2, name: "general", email: 'test-1@example.com')
      visit root_path
    end

    context 'Admin User' do
      it 'can login action' do
        within('header') do
          click_on 'ログイン'
        end
        fill_in 'Email', with: @admin_user.email
        fill_in 'パスワード', with: @admin_user.password
        within('.card') do
          click_on 'ログイン'
        end
        expect(page).to have_content 'Signed in successfully.'
      end
    end

    context 'Registrated (Created account) User' do
      it 'can login' do
        within('header') do
          click_on 'ログイン'
        end
        fill_in 'Email', with: @general_user.email
        fill_in 'パスワード', with: @general_user.password
        within('.card') do
          click_on 'ログイン'
        end
        expect(page).to have_content 'Signed in successfully.'
      end
      it 'can logout' do
        within('header') do
          click_on 'ログイン'
        end
        fill_in 'Email', with: @general_user.email
        fill_in 'パスワード', with: @general_user.password
        within('.card') do
          click_on 'ログイン'
        end
        within('header') do
          click_on 'ログアウト'
        end
        expect(page).to have_content 'Signed out successfully.'
      end
    end

    context 'Guest (one-click login) User,' do
      it 'can login' do
        within('header') do
          click_on 'ゲストログイン'
        end
        expect(page).to have_content 'Loged in as Guest User.'
      end
      it 'can logout' do
        within('header') do; click_on 'ゲストログイン'; end
        within('header') do; click_on 'ログアウト'; end
        expect(page).to have_content 'Signed out successfully.'
      end
    end
  end

  describe '#edit:' do
    before do
      # @brand = FactoryBot.create(:brand)
      @admin_user = FactoryBot.create(:user, name: "admin", admin: true)
      @general_user = FactoryBot.create(:user, id: 2, name: "general", email: 'test-1@example.com')
      visit root_path
    end

    describe 'General(registrated) User,' do
      before do
        within('header') do
          find(:css, 'button.dropdown-toggle').click
          click_on 'ログイン'
        end

        fill_in 'Email', with: @general_user.email
        fill_in 'パスワード', with: @general_user.password
        within('.card') do
          click_on 'ログイン'
        end

        within('header') do
          find(:css, 'button.dropdown-toggle').click
          click_on 'プロフィール'
        end

        find(:css, '.user_edit').click
      end

      it 'can change Name' do
        fill_in 'ユーザー名', with: 'BuzzFizz'
        fill_in 'パスワード (変更前パスワード)', with: @general_user.password
        click_on 'プロフィール編集'

        expect(page).to have_content 'Your account has been updated successfully.'
        within('header') do
          click_on 'プロフィール'
        end
        expect(page).to have_content 'BuzzFizz'
      end

      it 'can change Email' do
        changed_email = 'general-2@example.com'
        fill_in 'Email', with: changed_email
        fill_in 'パスワード (変更前パスワード)', with: @general_user.password
        click_on 'プロフィール編集'

        expect(page).to have_content 'Your account has been updated successfully.'

        within('header') do
          click_on 'ログアウト'
        end
        within('header') do
          click_on 'ログイン'
        end
        fill_in 'Email', with: @general_user.email
        fill_in 'パスワード', with: @general_user.password
        within('.card') do
          click_on 'ログイン'
        end
        expect(page).to have_content 'Invalid Email or password.'

        fill_in 'Email', with: changed_email
        fill_in 'パスワード', with: @general_user.password
        within('.card') do
          click_on 'ログイン'
        end
        expect(page).to have_content 'Signed in successfully.'
      end

      it 'can change Password', js: true do
        changed_password = '!@#%^&*pAsS'

        click_on 'パスワード 変更'
        fill_in 'パスワード', with: changed_password
        fill_in 'パスワード再入力', with: changed_password
        fill_in 'パスワード (変更前パスワード)', with: @general_user.password
        click_on 'プロフィール編集'

        expect(page).to have_content 'Your account has been updated successfully.'
        within('header') do
          find(:css, 'button.dropdown-toggle').click
          click_on 'ログアウト'
        end
        within('header') do
          find(:css, 'button.dropdown-toggle').click
          click_on 'ログイン'
        end
        fill_in 'Email', with: @general_user.email
        fill_in 'パスワード', with: @general_user.password
        within('.card') do
          click_on 'ログイン'
        end
        expect(page).to have_content 'Invalid Email or password.'

        fill_in 'Email', with: @general_user.email
        fill_in 'パスワード', with: changed_password
        within('.card') do
          click_on 'ログイン'
        end
        expect(page).to have_content 'Signed in successfully.'
      end
    end
  end

  private

  def fill_in_all_form
    fill_in "ユーザー名", with: 'Michael Smith'
    fill_in "Email", with: 'michael-m@example.com'
    fill_in "パスワード", with: 'password'
    fill_in "パスワード再入力", with: 'password'
    find(:css, "#agreement").set(true)
  end
end
