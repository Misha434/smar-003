require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @brand = FactoryBot.create(:brand)
    @product = FactoryBot.create(:product)
    @user = FactoryBot.create(:user)
    @review = FactoryBot.build(:review)
  end
  describe 'Content Form filled-out' do
    it 'is valid' do
      expect(@review).to be_valid
    end
    it 'with an attached image is valid' do
      @review.image = fixture_file_upload("files/image/image_test_logo.png")
      expect(@review).to be_valid
    end
  end
  describe 'Select Product form' do
    context "about ID range" do
      it 'is invalid with empty' do
        review = FactoryBot.build(:review, product_id: nil)
        expect(review).to_not be_valid
      end
      it 'is invalid with space' do
        review = FactoryBot.build(:review, product_id: " 　")
        expect(review).to_not be_valid
      end
      it 'is invalid with product_id: -1' do
        review = FactoryBot.build(:review, product_id: -1)
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing product_id: 0' do
        review = FactoryBot.build(:review, product_id: 0)
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing product_id selected' do
        review = FactoryBot.build(:review, product_id: 2)
        expect(review).to_not be_valid
      end
    end
    context "about data-type" do
      it 'of string or text is valid' do
        review = FactoryBot.build(:review, product_id: "1")
        expect(review).to be_valid
        review.save!
        expect(review.product_id.class).to eq(Integer)
      end
      it 'of string or text has full-width charactor is invalid' do
        review = FactoryBot.build(:review, product_id: "１")
        expect(review).to_not be_valid
      end
      it 'of integer is valid' do
        review = FactoryBot.build(:review, product_id: 1)
        expect(review).to be_valid
      end
      it 'of float is invalid' do
        review = FactoryBot.build(:review, product_id: 1.1)
        expect(review).to_not be_valid
      end
      it 'of boolean true is invalid' do
        review = FactoryBot.build(:review, product_id: true)
        expect(review).to_not be_valid
      end
      it 'of boolean false is invalid' do
        review = FactoryBot.build(:review, product_id: false)
        expect(review).to_not be_valid
      end
    end
  end
  describe 'Reviewer User' do
    context "about ID range" do
      it 'is invalid with empty' do
        review = FactoryBot.build(:review, user_id: nil)
        expect(review).to_not be_valid
      end
      it 'is invalid with space' do
        review = FactoryBot.build(:review, user_id: " 　")
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing user_id: -1' do
        review = FactoryBot.build(:review, user_id: -1)
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing user_id: 0' do
        review = FactoryBot.build(:review, user_id: 0)
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing user_id selected' do
        review = FactoryBot.build(:review, user_id: 2)
        expect(review).to_not be_valid
      end
    end
    context "about data-type" do
      it 'of string or text is valid' do
        review = FactoryBot.build(:review, user_id: "1")
        expect(review).to be_valid
        review.save!
        expect(review.user_id.class).to eq(Integer)
      end
      it 'of string or text has full-width charactor is invalid' do
        review = FactoryBot.build(:review, user_id: "１")
        expect(review).to_not be_valid
      end
      it 'of integer is valid' do
        review = FactoryBot.build(:review, user_id: 1)
        expect(review).to be_valid
      end
      it 'of float is invalid' do
        review = FactoryBot.build(:review, user_id: 1.1)
        expect(review).to_not be_valid
      end
      it 'of boolean true is invalid' do
        review = FactoryBot.build(:review, user_id: true)
        expect(review).to_not be_valid
      end
      it 'of boolean false is invalid' do
        review = FactoryBot.build(:review, user_id: false)
        expect(review).to_not be_valid
      end
    end
  end
  describe 'Rate' do
    context "about value range" do
      it 'is invalid with empty' do
        review = FactoryBot.build(:review, rate: nil)
        expect(review).to_not be_valid
      end
      it 'is invalid with space' do
        review = FactoryBot.build(:review, rate: " 　")
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing rate: -1' do
        review = FactoryBot.build(:review, rate: -1)
        expect(review).to_not be_valid
      end
      it 'is invalid with not existing rate: 0' do
        review = FactoryBot.build(:review, rate: 0)
        expect(review).to_not be_valid
      end
      it 'is valid with existing rate: 1' do
        review = FactoryBot.build(:review, rate: 1)
        expect(review).to be_valid
      end
      it 'is valid with existing rate: 5' do
        review = FactoryBot.build(:review, rate: 5)
        expect(review).to be_valid
      end
      it 'is invalid with not existing rate selected' do
        review = FactoryBot.build(:review, rate: 6)
        expect(review).to_not be_valid
      end
    end
    context "about data-type" do
      it 'of string or text is valid' do
        review = FactoryBot.build(:review, rate: "3")
        expect(review).to be_valid
        review.save!
        expect(review.rate.class).to eq(Integer)
      end
      it 'of integer is valid' do
        review = FactoryBot.build(:review, rate: 1)
        expect(review).to be_valid
      end
      it 'of float is invalid' do
        review = FactoryBot.build(:review, rate: 1.1)
        expect(review).to_not be_valid
      end
      it 'of boolean true is invalid' do
        review = FactoryBot.build(:review, rate: true)
        expect(review).to_not be_valid
      end
      it 'of boolean false is invalid' do
        review = FactoryBot.build(:review, rate: false)
        expect(review).to_not be_valid
      end
    end
  end
  describe "Content Form" do
    describe "filled with word length" do
      context "is 0(zero)" do
        it "is invalid" do
          review = FactoryBot.build(:review, content: "")
          expect(review).to_not be_valid
        end
      end
      context "is 1" do
        it "is valid" do
          review = FactoryBot.build(:review, content: "a")
          expect(review).to be_valid
        end
      end
      context "is 140" do
        it "is valid" do
          review = FactoryBot.build(:review,
                                    content: "Adolph Blain Charles Dave Frederick Hubert Adolph Blaine Charles Dave Early Frederick Hubert Adolph Blaine Charles Dave Early Frederick Dave")
          expect(review).to be_valid
        end
      end
      context "is 141" do
        it "is invalid" do
          review = FactoryBot.build(:review,
                                    content: "Adolphe Blain Charles Dave Frederick Hubert Adolph Blaine Charles Dave Early Frederick Hubert Adolph Blaine Charles Dave Early Frederick Dave")
          expect(review).to_not be_valid
        end
      end
    end
  end
  describe "Charactor Type" do
    context "漢字・ひらがな・カタカナ(全角)" do
      it "is valid" do
        review = FactoryBot.build(:review,
                                  content: "吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめ")
        expect(review).to be_valid
      end
    end
    context "半角カタカナ" do
      it "is valid" do
        review = FactoryBot.build(:review,
                                  content: "ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂ")
        expect(review).to be_valid
      end
    end
    context "English(Upper/Down Case)" do
      it "is valid" do
        review = FactoryBot.build(:review,
                                  content: "From fairest creatures we desire increase, That From fairest creatures we desire increase, That From fairest creatures we desire increase fa")
        expect(review).to be_valid
      end
    end
    context "symbol" do
      it "is valid" do
        review = FactoryBot.build(:review,
                                  content: "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγ")
        expect(review).to be_valid
      end
    end
    context "Number" do
      it "is valid" do
        review = FactoryBot.build(:review,
                                  content: "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２558388991646493833403４５３１７５１９０２４８７５１０４３６５１８２")
        expect(review).to be_valid
      end
    end
    context "Emoji" do
      it "is invalid (4Byte)" do
        review = FactoryBot.build(:review, content: "👨" * 140)
        expect(review).to be_valid
      end
      it "is invalid over 140 charactors" do
        review = FactoryBot.build(:review, content: "👨" * 141)
        expect(review).to_not be_valid
      end
    end
  end
  describe "Posted Review" do
    before do
      @review.save!
    end
    context "for the same product" do
      it "should raise error ActiveRecord::RecordNotUnique" do
        expect do
          review = FactoryBot.build(:review, id: 2)
          review.save!
        end.to raise_error( ActiveRecord::RecordNotUnique )
      end
    end
    context "for other product" do
      it "is valid" do
        FactoryBot.create(:product, id: 2, name: "Phone-2")
        review = FactoryBot.build(:review, product_id: 2)
        expect(review).to be_valid
      end
    end
  end
  describe "image" do
    describe "File" do
      context "has a GIF format" do
        it "is valid" do
          @review.image = fixture_file_upload("files/image/image_test_3kb.gif")
          expect(@review).to be_valid
        end
      end
      context "has a jpeg format" do
        it "is valid" do
          @review.image = fixture_file_upload("files/image/image_test_3kb.jpeg")
          expect(@review).to be_valid
        end
      end
      context "has a PNG format" do
        it "is valid" do
          @review.image = fixture_file_upload("files/image/image_test_3kb.png")
          expect(@review).to be_valid
        end
      end
      context "has a SVG format" do
        it "is invalid" do
          @review.image = fixture_file_upload("files/image/image_test_3kb.svg")
          expect(@review).to_not be_valid
        end
      end
      context "has a PSD format" do
        it "is invalid" do
          @review.image = fixture_file_upload("files/image/image_test_3kb.psd")
          expect(@review).to_not be_valid
        end
      end
      context "has a BMP format" do
        it "is invalid" do
          @review.image = fixture_file_upload("files/image/image_test_3kb.bmp")
          expect(@review).to_not be_valid
        end
      end
    end
    describe "File size" do
      it "5MB is valid" do
        @review.image = fixture_file_upload("files/image/image_test_5mb.jpeg")
        expect(@review).to be_valid
      end
      it "6MB is invalid" do
        @review.image = fixture_file_upload("files/image/image_test_6mb.jpeg")
        expect(@review).to_not be_valid
      end
    end
  end
end