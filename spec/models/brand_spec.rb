require 'rails_helper'

RSpec.describe Brand, type: :model do
  before do
    @brand = FactoryBot.build(:brand)
  end
  describe 'Name Form filled-out' do
    it 'is a valid' do
      expect(@brand).to be_valid
    end
    it 'with an attached image is a valid' do
      @brand.image = fixture_file_upload("files/image/image_test_logo.png")
      expect(@brand).to be_valid
    end
  end
  describe "Name Form" do
    describe "filled with word length" do
      context "is 0(zero)" do
        it "is invalid" do
          brand = FactoryBot.build(:brand, name: "")
          expect(brand).to_not be_valid
        end
      end
      context "is 1" do
        it "is valid" do
          brand = FactoryBot.build(:brand, name: "a")
          expect(brand).to be_valid
        end
      end
      context "is 50" do
        it "is valid" do
          brand = FactoryBot.build(:brand, name: "Adolph Blaine Charles David Early Frederick Hubert")
          expect(brand).to be_valid
        end
      end
      context "is 51" do
        it "is invalid" do
          brand = FactoryBot.build(:brand, name: "Hubert Irvin John Kenneth Lloyd Martine Oliver Paul")
          expect(brand).to_not be_valid
        end
      end
    end
  end
  describe "Charactor Type" do
    context "漢字・ひらがな・カタカナ(全角)" do
      it "is valid" do
        brand = FactoryBot.build(:brand, name: "吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー")
        expect(brand).to be_valid
      end
    end
    context "半角カタカナ" do
      it "is valid" do
        brand = FactoryBot.build(:brand, name: "ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ")
        expect(brand).to be_valid
      end
    end
    context "English(Upper/Down Case)" do
      it "is valid" do
        brand = FactoryBot.build(:brand, name: "From fairest creatures we desire increase, That th")
        expect(brand).to be_valid
      end
    end
    context "symbol" do
      it "is valid" do
        brand = FactoryBot.build(:brand, name: "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν")
        expect(brand).to be_valid
      end
    end
    context "Number" do
      it "is valid" do
        brand = FactoryBot.build(:brand, name: "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583")
        expect(brand).to be_valid
      end
    end
    context "Emoji" do
      it "is valid" do
        brand = FactoryBot.build(:brand, name: "👨" * 50)
        expect(brand).to be_valid
      end
      it "is invalid 51 charactors" do
        brand = FactoryBot.build(:brand, name: "👨" * 51)
        expect(brand).to_not be_valid
      end
    end
  end
  describe "Registrated Name" do
    before do
      @brand.save!
    end
    describe 'in same Upper/Down cases' do
      it "is invalid" do
        same_name_brand = FactoryBot.build(:brand)
        expect(same_name_brand).to_not be_valid
      end
    end
    describe 'in same Upper cases' do
      it "is invalid" do
        same_name_brand = FactoryBot.build(:brand, name: "APPLE")
        expect(same_name_brand).to_not be_valid
      end
    end
    describe 'in same down cases' do
      it "is invalid" do
        same_name_brand = FactoryBot.build(:brand, name: "apple")
        expect(same_name_brand).to_not be_valid
      end
    end
    describe 'in Japanese,' do
      it "ひらがな and 全角カタカナ is valid" do
        same_name_brand_hiragana = FactoryBot.build(:brand, name: "あっぷる")
        same_name_brand_full_width_katakana = FactoryBot.build(:brand, name: "アップル")
        expect(same_name_brand_hiragana).to be_valid
        expect(same_name_brand_full_width_katakana).to be_valid
      end
      it "半角カタカナ and 全角カタカナ is valid" do
        same_name_brand_half_width_katakana = FactoryBot.build(:brand, name: "ｱｯﾌﾟﾙ")
        same_name_brand_full_width_katakana = FactoryBot.build(:brand, name: "アップル")
        expect(same_name_brand_half_width_katakana).to be_valid
        expect(same_name_brand_full_width_katakana).to be_valid
      end
    end
  end
  describe "image" do
    describe "File" do
      context "has a GIF format" do
        it "is valid" do
          @brand.image = fixture_file_upload("files/image/image_test_3kb.gif")
          expect(@brand).to be_valid
        end
      end
      context "has a jpeg format" do
        it "is valid" do
          @brand.image = fixture_file_upload("files/image/image_test_3kb.jpeg")
          expect(@brand).to be_valid
        end
      end
      context "has a PNG format" do
        it "is valid" do
          @brand.image = fixture_file_upload("files/image/image_test_3kb.png")
          expect(@brand).to be_valid
        end
      end
      context "has a SVG format" do
        it "is invalid" do
          @brand.image = fixture_file_upload("files/image/image_test_3kb.svg")
          expect(@brand).to_not be_valid
        end
      end
      context "has a PSD format" do
        it "is invalid" do
          @brand.image = fixture_file_upload("files/image/image_test_3kb.psd")
          expect(@brand).to_not be_valid
        end
      end
      context "has a BMP format" do
        it "is invalid" do
          @brand.image = fixture_file_upload("files/image/image_test_3kb.bmp")
          expect(@brand).to_not be_valid
        end
      end
    end
    describe "File size" do
      it "5MB is valid" do
        @brand.image = fixture_file_upload("files/image/image_test_5mb.jpeg")
        expect(@brand).to be_valid
      end
      it "6MB is invalid" do
        @brand.image = fixture_file_upload("files/image/image_test_6mb.jpeg")
        expect(@brand).to_not be_valid
      end
    end
  end
end
