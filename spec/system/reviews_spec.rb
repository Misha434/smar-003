require 'rails_helper'

RSpec.describe Review, type: :system do
  
  def ensure_browser_size(width = 1280, height = 720)
    Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
  end
  def fill_in_review_form
    select "Apple"
    select "Phone-1"
    fill_in 'review[content]', with: @review.content
  end
  def create_review(i)
    i = i.to_i
    i.times do |n|
      content = "review #{ n + 1 }"
      Brand.create!(
        id: n + 1,
        content: content
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
  before do
    @brand = FactoryBot.build(:brand)
    @product = FactoryBot.build(:product)
    @review = FactoryBot.build(:review)
    visit root_path
  end
  # Modify format Start 
  describe 'As Admin User,' do
    before do
      @admin_user = FactoryBot.create(:user, admin: true)
      within('header') do
        find(:css, "button.dropdown-toggle").click
        click_on "Login"
      end
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @admin_user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    describe 'Create Action' do
      before do
        @brand.save!
        @product.save!
      end
      describe 'reviews#new' do
        before do
          visit '/reviews/new'
          fill_in_review_form
        end
        context 'filled in content field' do
          it 'is available' do
            click_button "Post"
            expect(page).to have_content 'Phone-1'
            expect(page).to have_content 'Awesome'
          end
        end
        context 'filled in content field and image' do
          it 'is available', js: true do
            attach_file "review_image",
                        "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
            click_button "Post"
            expect(page).to have_content 'Aaron'
            expect(page).to have_content 'Awesome'
            expect(page).to have_css("img[src$='image_test_logo.png']")
          end
        end
        describe 'about content field' do
          describe 'charactor count' do
            context 'is 0(zero)' do
              it 'is unavailable' do
                fill_in 'review[content]', with: ''
                click_button "Post"
                expect(page).to have_content 'Post Review'
                expect(page).to have_content "Content can't be blank"
              end
            end
            context 'is 1' do
              it 'is available' do
                fill_in 'review[content]', with: 'X'
                click_button "Post"
                expect(page).to have_content 'X'
              end
            end
            context 'is 140' do
              it 'is available' do
                testdata_content = 'Aaron and associates Example Company East Asia Inc Aaron and associates Example Company East Asia Inc associates Exact Company East Asia Inc'
                fill_in 'review[content]', with: testdata_content
                click_button "Post"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 141' do
              it 'is unavailable' do
                testdata_content = 'Aarone and associates Example Company East Asia Inc Aaron and associates Example Company East Asia Inc associates Exact Company East Asia Inc'
                fill_in 'review[content]', with: testdata_content
                click_button "Post"
                expect(page).to have_content 'Post Review'
                expect(page).to have_content "Content is too long"
              end
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_content = '吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当けんとうがつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々'
                fill_in 'review[content]', with: testdata_content
                click_button "Post"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_content = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂ'
                fill_in 'review[content]', with: testdata_content
                click_button "Post"
                expect(page).to have_content testdata_content
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_content = "From fairest creatures we desire increase, That thereby beauty’s rose might never die, But as the riper should by time decease, His tender h"
              fill_in 'review[content]', with: testdata_content
              click_button "Post"
              expect(page).to have_content testdata_content
            end
          end
          context "symbol" do
            it "is available" do
              testdata_content = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγ"
              fill_in 'review[content]', with: testdata_content
              click_button "Post"
              expect(page).to have_content testdata_content
            end
          end
          context "Number" do
            it "is available" do
              testdata_content = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２"
              fill_in 'review[content]', with: testdata_content
              click_button "Post"
              expect(page).to have_content testdata_content
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_content = "👨" * 140
              fill_in 'review[content]', with: testdata_content
              click_button "Post"
              expect(page).to have_content testdata_content
            end
            it "is unavailable 141 charactors" do
              testdata_content = "👨" * 141
              fill_in 'review[content]', with: testdata_content
              click_button "Post"
              expect(page).to have_content 'Post Review'
              expect(page).to have_content 'too long'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'review[content]', with: ' 　'
              click_button "Post"
              expect(page).to have_content 'Post Review'
              expect(page).to have_content "can't be blank"
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path #reload
            end
            it 'is unavailable' do
              fill_in 'review[content]', with: @review.content
              expect(page).to have_content 'Post Review'
            end
          end
        end
        describe 'about image field', js: true do
          before do
            fill_in_review_form
          end
          describe 'file format' do
            context 'gif' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.gif"
                click_button "Post"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.gif']")
              end
            end
            context 'jpeg' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.jpeg"
                click_button "Post"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.jpeg']")
              end
            end
            context 'png' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.png"
                click_button "Post"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.png']")
              end
            end
            context 'svg' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                click_button "Post"
                expect(page).to have_content 'Post Review'
                expect(page).to have_content 'Image must be a valid image format'
              end
            end
            context 'bmp' do
              it 'is unavailable' do
                attach_file "review_image",
                "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                click_button "Post"
                expect(page).to have_content 'Post Review'
                expect(page).to have_content 'Image must be a valid image format'
              end
            end
          end
          describe 'file size' do
            context 'less then 5MB' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review_5mb.jpeg"
                click_button "Post"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review_5mb.jpeg']")
              end
            end
            context 'greater than 6MB' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review_6mb.jpeg"
                expect(page.driver.browser.switch_to.alert.text).to eq "Maximum file size is 5MB. Please choose a smaller file."
              end
            end
          end
        end
      end
      describe 'users#show' do
        before do
          visit '/users/1'
          fill_in_review_form
        end
        it 'is available' do
          pending 'WIP'
        end
      end
    end
    # describe 'products#show' do
    #   before do
    #     @brand.save!
    #     @product.save!
    #     click_on 'All Products'
    #     click_on 'Phone-1'
    #   end
    #   describe 'Brand Title' do
    #     it 'indicates correct brand name' do
    #       expect(page).to have_content('Apple')
    #     end
    #     it 'edits brand link is available' do
    #       within('.brand_title') do
    #         find(:css,'.edit_link').click
    #       end
    #       expect(page).to have_content('Edit Review')
    #     end
    #   end
    #   describe 'each product' do
    #     it 'indicates correct name' do
    #       within('#product-1') do
    #         expect(page).to have_content('Phone-1')
    #       end
    #     end
    #   end
    #   describe 'product link' do
    #     it 'is available' do
    #       within('#product-1') do
    #         expect(page).to have_content('Phone-1')
    #       end
    #       expect(page).to have_content('Apple')
    #       expect(page).to have_content('Phone-1')
    #     end
    #     it 'for editing product is available' do
    #       within('#product-1') do
    #         find(:css,'.edit_link').click
    #       end
    #       expect(page).to have_content('Edit Product')
    #     end
    #   end
    #   describe 'review count' do
    #     before do
    #       within('#product-1') do
    #         expect(page).to have_content('Phone-1')
    #       end
    #     end
    #     context 'if 1 review exist' do
    #       it 'is correct' do
    #         FactoryBot.create(:review)
    #         visit current_path
    #         expect(page).to have_content('1 review')
    #       end
    #     end
    #     context 'if 2 reviews exist' do
    #       it 'is correct' do
    #         FactoryBot.create(:user, id: 2, name: 'user2', email: "test-1@example.com")
    #         FactoryBot.create(:review)
    #         FactoryBot.create(:review, id: 2, user_id: 2)
    #         visit current_path
    #         within('#product-1') do
    #           expect(page).to have_content('2 reviews')
    #         end
    #       end
    #     end
    #   end
    # end
    describe 'Update Action' do
      before do
        @brand.save!
        @product.save!
        @review.save!
      end
      describe 'from users#show' do
        before do
          click_on 'Profile'
          within('#review-1') do
            find(:css, '.review_edit_link').click
          end
        end
        it 'is available' do
          content = '吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕まえて'
          fill_in 'review[content]', with: content
          click_button "Edit"
          expect(page).to have_content 'Aaron'
          expect(page).to have_content content
        end
      end
      describe 'from products#show' do
        before do
          click_on 'All Products'
          click_on 'Phone-1'
          within('#review-1') do
            find(:css, '.review_edit_link').click
          end
        end
        it 'is available' do
          content = '吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕まえて'
          fill_in 'review[content]', with: content
          click_button "Edit"
          expect(page).to have_content 'Aaron'
          expect(page).to have_content content
        end
      end
      describe 'Edit form validation' do
        before do
          click_on 'All Products'
          click_on 'Phone-1'
          within('#review-1') do
            find(:css, '.review_edit_link').click
          end
        end
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              fill_in 'review[content]', with: ''
              click_button "Edit"
              expect(page).to have_content 'Edit Review'
              expect(page).to have_content "Content can't be blank"
            end
          end
          context 'is 1' do
            it 'is available' do
              fill_in 'review[content]', with: 'X'
              click_button "Edit"
              expect(page).to have_content 'X'
            end
          end
          context 'is 140' do
            it 'is available' do
              testdata_content = '吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕まえて'
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content testdata_content
            end
          end
          context 'is 141' do
            it 'is unavailable' do
              testdata_content = '吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕まえては'
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content 'Edit Review'
              expect(page).to have_content "Content is too long"
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_content = '吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕まえて'
                fill_in 'review[content]', with: testdata_content
                click_button "Edit"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_content = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂ'
                fill_in 'review[content]', with: testdata_content
                click_button "Edit"
                expect(page).to have_content testdata_content
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_content = "When forty winters shall besiege thy brow, And dig deep trenches in thy beauty’s field, Thy youth’s proud livery so gazed on now, Will be ab"
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content testdata_content
            end
          end
          context "symbol" do
            it "is available" do
              testdata_content = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγ"
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content testdata_content
            end
          end
          context "Number" do
            it "is available" do
              testdata_content = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２"
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content testdata_content
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_content = "👨" * 140
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content testdata_content
            end
            it "is unavailable 141 charactors" do
              testdata_content = "👨" * 141
              fill_in 'review[content]', with: testdata_content
              click_button "Edit"
              expect(page).to have_content 'Edit Review'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'review[content]', with: ' 　'
              expect(page).to have_content 'Edit Review'
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path #reload
            end
            it 'is unavailable' do
              fill_in 'review[content]', with: @review.content
              expect(page).to have_content 'Edit Review'
            end
          end
          describe 'about image field' do
            before do
              fill_in 'review[content]', with: @review.content
            end
            describe 'file format' do
              context 'gif' do
                it 'is available' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.gif"
                  click_button "Edit"
                  expect(page).to have_content @review.content
                  expect(page).to have_css("img[src$='image_test_3kb.gif']")
                end
              end
              context 'jpeg' do
                it 'is available' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.jpeg"
                  click_button "Edit"
                  expect(page).to have_content @review.content
                  expect(page).to have_css("img[src$='image_test_3kb.jpeg']")
                end
              end
              context 'png' do
                it 'is available' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.png"
                  click_button "Edit"
                  expect(page).to have_content @review.content
                  expect(page).to have_css("img[src$='image_test_3kb.png']")
                end
              end
              context 'svg' do
                it 'is unavailable' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                  click_button "Edit"
                  expect(page).to have_content 'Edit Review'
                end
              end
              context 'bmp' do
                it 'is unavailable' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                  click_button "Edit"
                  expect(page).to have_content 'Edit Review'
                end
              end
            end
            describe 'file size' do
              context 'less then 5MB' do
                it 'is available' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_5mb.jpeg"
                  click_button "Edit"
                  expect(page).to have_content 'Apple'
                  expect(page).to have_css("img[src$='image_test_5mb.jpeg']")
                end
              end
              context 'greater than 6MB' do
                it 'is unavailable' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_6mb.jpeg"
                  click_button "Edit"
                  expect(page).to have_content 'Edit Review'
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
        @review.save!
        click_on 'Brands'
        click_on 'Apple'
        within('.brand_title') do
          find(:css,'.edit_link').click
        end
      end
      xdescribe 'in brands#edit' do
        it 'is available' do
          expect(page).to have_content 'Edit Review'
          click_button 'Delete'
          expect(page).to have_content 'Apple'
        end
        describe 'works dependency' do
          before do
            within('.d-grid') do
              click_on 'Delete'
            end
          end
          it 'in products#index' do
            visit '/products'
            expect(page).to_not have_content 'Phone-1'
          end
          it 'in products#show' do
            visit '/products/1'
            expect(page).to have_content 'Phone-1'
            click_on 'Apple'
            find(:css, 'h2') do
              expect(page).to have_content 'ブランド'
            end
            expect(page).to have_content 'Brand is not exist'
          end
        end
      end
    end
  end
  describe 'As Registrated User,' do
    before do
      @registrated_user = FactoryBot.create(:user)
      within('header') do
        click_on "Login"
      end
      fill_in "Email", with: @registrated_user.email
      fill_in "Password", with: @registrated_user.password
      click_button "Log in"
      expect(page).to have_content 'Signed in'
    end
    describe 'Create Action' do
      it 'is not available' do
        visit '/brands/new'
        expect(page).to_not have_content 'Post Review'
        expect(page).to have_content 'Aaron'
        expect(page).to have_content 'Access denied'
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
        click_on 'Brands'
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
        expect(page).to_not have_content 'Edit Review'
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
        expect(page).to_not have_content 'Post Review'
        expect(page).to have_content 'Log in'
        fill_in "Email", with: @registrated_user.email
        fill_in "Password", with: @registrated_user.password
        click_button "Log in"
        expect(page).to have_content 'Access denied'
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
        click_on 'Brands'
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
        expect(page).to have_content 'Log in'
        fill_in "Email", with: @registrated_user.email
        fill_in "Password", with: @registrated_user.password
        click_button "Log in"
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Delete Action' do
      before do
        @brand.save!
      end
      it 'can access brand destroy page' do
        page.driver.submit :delete, '/brands/1', {}
        expect(page).to have_content 'Log in'
        fill_in "Email", with: @registrated_user.email
        fill_in "Password", with: @registrated_user.password
        click_button "Log in"
        click_on "Brands"
        expect(page).to have_content 'Apple'
      end
    end
  end
end