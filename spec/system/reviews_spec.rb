require 'rails_helper'

RSpec.describe Review, type: :system do
  def ensure_browser_size(width = 1280, height = 720)
    Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
  end

  def fill_in_review_form
    select "Apple"
    select "Phone-1"
    select "★★★☆☆"
    fill_in 'review[content]', with: @review.content
  end

  def create_review(review_amount)
    review_amount = review_amount.to_i
    review_amount.times do |n|
      content = "review #{n + 1}"
      Brand.create!(
        id: n + 1,
        content: content
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
      image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
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
    @like = FactoryBot.build(:like, user_id: 1, review_id: 1)
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
        @product.save!
      end
      describe 'reviews#new' do
        before do
          visit '/reviews/new'
          fill_in_review_form
        end
        context 'filled in content field' do
          it 'is available' do
            click_button "投稿"
            expect(page).to have_content 'Phone-1'
            expect(page).to have_content 'Awesome'
          end
        end
        context 'filled in content field and image' do
          it 'is available', js: true do
            attach_file "review_image",
                        "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
            click_button "投稿"
            expect(page).to have_content 'Aaron'
            expect(page).to have_content 'Awesome'
            expect(page).to have_css("img[src$='image_test_logo.png']")
          end
        end
        context 'about select fields(Brand, Product)', js: true do
          describe 'Form' do
            before do
              FactoryBot.create(:brand, id: 2, name: "Example Inc")
              FactoryBot.create(:brand, id: 3, name: "Example Exp")
              FactoryBot.create(:product, id: 2, name: "Phone-2")
              FactoryBot.create(:product, id: 3, brand_id: 2, name: "Phone-3")
              visit current_path
              fill_in_review_form
            end
            it 'Product are indicated correctry(selected Apple)' do
              select 'Apple'
              select 'Phone-2'
              click_button "投稿"
              expect(page).to have_content 'Aaron'
              expect(page).to have_content 'Awesome'
              expect(page).to have_content 'Phone-2'
            end
            it 'Product are indicated correctry(selected Example Inc)' do
              select 'Example Inc'
              select 'Phone-3'
              click_button "投稿"
              expect(page).to have_content 'Aaron'
              expect(page).to have_content 'Awesome'
              expect(page).to have_content 'Phone-3'
            end
            it 'Brand is enpty, should be invalid' do
              select '--- ブランド ---'
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
            end
            it 'Product is enpty, should be invalid' do
              select 'Example Exp'
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
            end
            it 'is enpty should be invalid (after selected Product)' do
              select 'Apple'
              select 'Phone-2'
              select '--- ブランド ---'
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
            end
          end
        end
        context 'about select fields(Rate)', js: true do
          describe 'Form' do
            it 'selected 1 is available' do
              select '★☆☆☆☆'
              click_button "投稿"
              within("#review-#{Review.last.id}") do
                expect(page).to have_selector('.active_star', count: 1)
                expect(page).to have_selector('.no_active_star', count: 4)
              end
            end
            it 'selected 2 is available' do
              select '★★☆☆☆'
              click_button "投稿"
              within("#review-#{Review.last.id}") do
                expect(page).to have_selector('.active_star', count: 2)
                expect(page).to have_selector('.no_active_star', count: 3)
              end
            end
            it 'selected 3 is available' do
              select '★★★☆☆'
              click_button "投稿"
              within("#review-#{Review.last.id}") do
                expect(page).to have_selector('.active_star', count: 3)
                expect(page).to have_selector('.no_active_star', count: 2)
              end
            end
            it 'selected 4 is available' do
              select '★★★★☆'
              click_button "投稿"
              within("#review-#{Review.last.id}") do
                expect(page).to have_selector('.active_star', count: 4)
                expect(page).to have_selector('.no_active_star', count: 1)
              end
            end
            it 'selected 5 is available' do
              select '★★★★★'
              click_button "投稿"
              within("#review-#{Review.last.id}") do
                expect(page).to have_selector('.active_star', count: 5)
                expect(page).to_not have_selector('.no_active_star')
              end
            end
          end
        end
        describe 'about content field' do
          describe 'charactor count' do
            context 'is 0(zero)' do
              it 'is unavailable' do
                fill_in 'review[content]', with: ''
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content "投稿内容 が入力されていません。"
              end
            end
            context 'is 1' do
              it 'is available' do
                fill_in 'review[content]', with: 'X'
                click_button "投稿"
                expect(page).to have_content 'X'
              end
            end
            context 'is 140' do
              it 'is available' do
                testdata_content = 'Aaron and associates Example Company East Asia Inc Aaron and associates Example Company East Asia Inc associates Exact Company East Asia Inc'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 141' do
              it 'is unavailable' do
                testdata_content = 'Aarone and associates Example Company East Asia Inc Aaron and associates Example Company East Asia Inc associates Exact Company East Asia Inc'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content "投稿内容 が長すぎます"
              end
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_content = '吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当けんとうがつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_content = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂ'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content testdata_content
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_content = "From fairest creatures we desire increase, That thereby beauty’s rose might never die, But as the riper should by time decease, His tender h"
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
          end
          context "symbol" do
            it "is available" do
              testdata_content = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγ"
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
          end
          context "Number" do
            it "is available" do
              testdata_content = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２"
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_content = "👨" * 140
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
            it "is unavailable 141 charactors" do
              testdata_content = "👨" * 141
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
              expect(page).to have_content '投稿内容 が長すぎます。'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'review[content]', with: ' 　'
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
              expect(page).to have_content "投稿内容 が入力されていません。"
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path # reload
            end
            it 'is unavailable' do
              fill_in 'review[content]', with: @review.content
              expect(page).to have_content 'レビュー投稿'
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
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.gif']")
              end
            end
            context 'jpeg' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.jpeg"
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.jpeg']")
              end
            end
            context 'png' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.png"
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.png']")
              end
            end
            context 'svg' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content 'Image must be a valid image format'
              end
            end
            context 'bmp' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content 'Image must be a valid image format'
              end
            end
          end
          describe 'file size' do
            context 'less then 5MB' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review_5mb.jpeg"
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review_5mb.jpeg']")
              end
            end
            context 'greater than 6MB' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review_6mb.jpeg"
                expect(page.driver.browser.switch_to.alert.text).to eq "画像の容量は5MBまでです。他の画像を選択してください。"
              end
            end
          end
        end
      end
      describe 'users#show' do
        it 'has posted review' do
          @review.save!
          click_on 'プロフィール'
          within('#review-1') do
            expect(page).to have_content @review.product.name
            expect(page).to have_content @review.content
          end
        end
      end
    end
    describe 'Update Action' do
      before do
        @brand.save!
        @product.save!
        @review.save!
      end
      describe 'from users#show' do
        before do
          click_on 'プロフィール'
          within('#review-1') do
            find(:css, '.review_edit_link').click
          end
          select "★★★☆☆"
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
          click_on '製品一覧'
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
          within('header') do
            find(:css, "button.navbar-toggler").click
          end
          click_on '製品一覧'
          click_on 'Phone-1'
          within('#review-1') do
            find(:css, '.review_edit_link').click
          end
        end
        context 'select fields(Rate)' do
          describe 'Form' do
            it 'selected 1 is available' do
              select '★☆☆☆☆'
              click_button "Edit"
              expect(page).to have_selector('.active_star', count: 1)
              expect(page).to have_selector('.no_active_star', count: 4)
            end
            it 'selected 2 is available' do
              select '★★☆☆☆'
              click_button "Edit"
              expect(page).to have_selector('.active_star', count: 2)
              expect(page).to have_selector('.no_active_star', count: 3)
            end
            it 'selected 3 is available' do
              select '★★★☆☆'
              click_button "Edit"
              expect(page).to have_selector('.active_star', count: 3)
              expect(page).to have_selector('.no_active_star', count: 2)
            end
            it 'selected 4 is available' do
              select '★★★★☆'
              click_button "Edit"
              expect(page).to have_selector('.active_star', count: 4)
              expect(page).to have_selector('.no_active_star', count: 1)
            end
            it 'selected 5 is available' do
              select '★★★★★'
              click_button "Edit"
              expect(page).to have_selector('.active_star', count: 5)
              expect(page).to_not have_selector('.no_active_star')
            end
          end
        end
        describe 'charactor count' do
          context 'is 0(zero)' do
            it 'is unavailable' do
              fill_in 'review[content]', with: ''
              click_button "Edit"
              expect(page).to have_content 'レビュー編集'
              expect(page).to have_content "投稿内容 が入力されていません。"
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
              expect(page).to have_content 'レビュー編集'
              expect(page).to have_content "投稿内容 が長すぎます"
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
              expect(page).to have_content 'レビュー編集'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'review[content]', with: ' 　'
              expect(page).to have_content 'レビュー編集'
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path # reload
            end
            it 'is unavailable' do
              fill_in 'review[content]', with: @review.content
              expect(page).to have_content 'レビュー編集'
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
                  expect(page).to have_content 'レビュー編集'
                end
              end
              context 'bmp' do
                it 'is unavailable' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                  click_button "Edit"
                  expect(page).to have_content 'レビュー編集'
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
                  expect(page).to have_content 'レビュー編集'
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
      end
      describe 'in products#show' do
        it 'is available' do
          click_on '製品一覧'
          click_on 'Phone-1'
          find(:css, '.review_edit_link').click
          expect(page).to have_content 'レビュー編集'
          find(:css, '.delete_link').click
          expect(page).to have_content 'Phone-1'
          expect(page).to have_content 'レビューが消去されました'
          expect(page).to_not have_content 'Awesome'
        end
        describe 'works dependency' do
          before do
            @like.save!
            click_on '製品一覧'
            click_on 'Phone-1'
            within('.like_count') do
              expect(page).to have_content '1'
            end
            click_on 'プロフィール'
            within('.like_count') do
              expect(page).to have_content '1'
            end
            find(:css, '.review_edit_link').click
            find(:css, '.delete_link').click
          end
          it 'in products#show(Brand, Product is still exist)' do
            expect(page).to have_content 'Phone-1'
            click_on 'Apple'
            expect(page).to have_content 'Phone-1'
          end
          it 'in products#show(like is deleted)' do
            expect(page).to have_content 'Phone-1'
            expect(page).to_not have_content 'Awesome'
            within('.like_count') do
              expect(page).to have_content '0'
            end
          end
          it 'in users#show' do
            click_on 'プロフィール'
            expect(page).to have_content '0'
            within('.like_count') do
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
        find(:css, "button.dropdown-toggle").click
        click_on "ログイン"
      end
      fill_in "Email", with: @registrated_user.email
      fill_in "パスワード", with: @registrated_user.password
      click_button "ログイン"
      expect(page).to have_content 'ログインしました。'
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
            click_button "投稿"
            expect(page).to have_content 'Phone-1'
            expect(page).to have_content 'Awesome'
          end
        end
        context 'filled in content field and image' do
          it 'is available', js: true do
            attach_file "review_image",
                        "#{Rails.root}/spec/fixtures/files/image/image_test_logo.png"
            click_button "投稿"
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
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content "投稿内容 が入力されていません。"
              end
            end
            context 'is 1' do
              it 'is available' do
                fill_in 'review[content]', with: 'X'
                click_button "投稿"
                expect(page).to have_content 'X'
              end
            end
            context 'is 140' do
              it 'is available' do
                testdata_content = 'Aaron and associates Example Company East Asia Inc Aaron and associates Example Company East Asia Inc associates Exact Company East Asia Inc'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 141' do
              it 'is unavailable' do
                testdata_content = 'Aarone and associates Example Company East Asia Inc Aaron and associates Example Company East Asia Inc associates Exact Company East Asia Inc'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content "投稿内容 が長すぎます"
              end
            end
          end
          describe 'charactor type' do
            context 'is 漢字・ひらがな・全角カタカナ' do
              it 'is available' do
                testdata_content = '吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当けんとうがつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content testdata_content
              end
            end
            context 'is 半角カタカナ' do
              it 'is available' do
                testdata_content = 'ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂ'
                fill_in 'review[content]', with: testdata_content
                click_button "投稿"
                expect(page).to have_content testdata_content
              end
            end
          end
          context "English(Upper/Down Case)" do
            it "is available" do
              testdata_content = "From fairest creatures we desire increase, That thereby beauty’s rose might never die, But as the riper should by time decease, His tender h"
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
          end
          context "symbol" do
            it "is available" do
              testdata_content = "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγ"
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
          end
          context "Number" do
            it "is available" do
              testdata_content = "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２"
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
          end
          context "Emoji" do
            it "is available" do
              testdata_content = "👨" * 140
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content testdata_content
            end
            it "is unavailable 141 charactors" do
              testdata_content = "👨" * 141
              fill_in 'review[content]', with: testdata_content
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
              expect(page).to have_content '投稿内容 が長すぎます。'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'review[content]', with: ' 　'
              click_button "投稿"
              expect(page).to have_content 'レビュー投稿'
              expect(page).to have_content "投稿内容 が入力されていません。"
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path # reload
            end
            it 'is unavailable' do
              fill_in 'review[content]', with: @review.content
              expect(page).to have_content 'レビュー投稿'
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
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.gif']")
              end
            end
            context 'jpeg' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.jpeg"
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.jpeg']")
              end
            end
            context 'png' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review.png"
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review.png']")
              end
            end
            context 'svg' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.svg"
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content 'Image must be a valid image format'
              end
            end
            context 'bmp' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                click_button "投稿"
                expect(page).to have_content 'レビュー投稿'
                expect(page).to have_content 'Image must be a valid image format'
              end
            end
          end
          describe 'file size' do
            context 'less then 5MB' do
              it 'is available' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review_5mb.jpeg"
                click_button "投稿"
                expect(page).to have_content @review.content
                expect(page).to have_css("img[src$='image_test_review_5mb.jpeg']")
              end
            end
            context 'greater than 6MB' do
              it 'is unavailable' do
                attach_file "review_image",
                            "#{Rails.root}/spec/fixtures/files/image/image_test_review_6mb.jpeg"
                expect(page.driver.browser.switch_to.alert.text).to eq "画像の容量は5MBまでです。他の画像を選択してください。"
              end
            end
          end
        end
      end
    end
    describe 'Index Action' do
      it 'is not available' do
        @brand.save!
        @product.save!
        @review.save!
        visit '/reviews'
        expect(page).to have_content 'Access denied'
      end
    end
    describe 'Show Action' do
      it 'has posted review' do
        @brand.save!
        @product.save!
        @review.save!
        click_on 'プロフィール'
        within('#review-1') do
          expect(page).to have_content @review.product.name
          expect(page).to have_content @review.content
        end
      end
    end
    describe 'Update Action' do
      before do
        @brand.save!
        @product.save!
        @review.save!
      end
      describe 'from users#show' do
        before do
          click_on 'プロフィール'
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
          click_on '製品一覧'
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
          click_on '製品一覧'
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
              expect(page).to have_content 'レビュー編集'
              expect(page).to have_content "投稿内容 が入力されていません。"
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
              expect(page).to have_content 'レビュー編集'
              expect(page).to have_content "投稿内容 が長すぎます"
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
              expect(page).to have_content 'レビュー編集'
            end
          end
          context "space" do
            it "only is unavailable" do
              fill_in 'review[content]', with: ' 　'
              expect(page).to have_content 'レビュー編集'
            end
          end
          describe 'registrated' do
            before do
              @brand.save!
              visit current_path # reload
            end
            it 'is unavailable' do
              fill_in 'review[content]', with: @review.content
              expect(page).to have_content 'レビュー編集'
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
                  expect(page).to have_content 'レビュー編集'
                end
              end
              context 'bmp' do
                it 'is unavailable' do
                  attach_file "review_image",
                              "#{Rails.root}/spec/fixtures/files/image/image_test_3kb.bmp"
                  click_button "Edit"
                  expect(page).to have_content 'レビュー編集'
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
                  expect(page).to have_content 'レビュー編集'
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
      end
      describe 'in products#show' do
        it 'is available' do
          click_on '製品一覧'
          click_on 'Phone-1'
          find(:css, '.review_edit_link').click
          expect(page).to have_content 'レビュー編集'
          find(:css, '.delete_link').click
          expect(page).to have_content 'Phone-1'
          expect(page).to have_content 'レビューが消去されました'
          expect(page).to_not have_content 'Awesome'
        end
        describe 'works dependency' do
          before do
            @like.save!
            click_on '製品一覧'
            click_on 'Phone-1'
            within('.like_count') do
              expect(page).to have_content '1'
            end
            click_on 'プロフィール'
            within('.like_count') do
              expect(page).to have_content '1'
            end
            find(:css, '.review_edit_link').click
            find(:css, '.delete_link').click
          end
          it 'Brand, Product is still exist' do
            expect(page).to have_content 'Phone-1'
            click_on 'Apple'
            expect(page).to have_content 'Phone-1'
          end
          it 'Like is deleted' do
            expect(page).to have_content 'Phone-1'
            expect(page).to_not have_content 'Awesome'
            within('.like_count') do
              expect(page).to have_content '0'
            end
          end
          it 'in users#show' do
            click_on 'プロフィール'
            expect(page).to have_content '0'
            within('.like_count') do
              expect(page).to have_content '0'
            end
          end
        end
      end
    end
  end

  describe 'As Guest User,' do
    before do
      @registrated_user = FactoryBot.create(:user)
      @brand.save!
      @product.save!
      @review.save!
      @like.save!
    end
    describe 'Create Action' do
      it 'require login' do
        visit '/reviews/new'
        expect(page).to_not have_content 'レビュー投稿'
        expect(page).to have_content 'ログイン'
      end
    end
    describe 'Index Action' do
      it 'require login' do
        @brand.save!
        @product.save!
        @review.save!
        visit '/reviews'
        expect(page).to have_content 'ログイン'
      end
    end
    describe 'Edit Action' do
      it 'require login' do
        visit '/reviews/1/edit'
        expect(page).to have_content 'ログイン'
      end
    end
    describe 'Delete Action' do
      it 'can access brand destroy page' do
        page.driver.submit :delete, '/reviews/1', {}
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
