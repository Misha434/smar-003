require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @brand = FactoryBot.create(:brand)
    @product = FactoryBot.build(:product)
  end
  describe 'Name Form filled-out' do
    it 'is a valid' do
      expect(@product).to be_valid
    end
    it 'with an attached image is a valid' do
      @product.image = fixture_file_upload("files/image/image_test_logo.png")
      expect(@product).to be_valid
    end
  end
  describe "Name Form" do
    describe "filled with word length" do
      it { should validate_presence_of(:name) }      
      it do
        should validate_length_of(:name).
        is_at_least(1).is_at_most(50)
      end
      it { should_not validate_length_of(:name).is_at_most(51) }
    end
    describe "Charactor Type" do
      context "漢字・ひらがな・カタカナ(全角)" do
        it "is valid" do
          product = FactoryBot.build(:product, name: "吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー")
          expect(product).to be_valid
        end
      end
      context "半角カタカナ" do
        it "is valid" do
          product = FactoryBot.build(:product, name: "ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽ")
          expect(product).to be_valid
        end
      end
      context "English(Upper/Down Case)" do
        it "is valid" do
          product = FactoryBot.build(:product, name: "From fairest creatures we desire increase, That th")
          expect(product).to be_valid
        end
      end
      context "symbol" do
        it "is valid" do
          product = FactoryBot.build(:product, name: "▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμν")
          expect(product).to be_valid
        end
      end
      context "Number" do
        it "is valid" do
          product = FactoryBot.build(:product, name: "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583")
          expect(product).to be_valid
        end
      end
      context "Emoji" do
        it "is valid" do
          product = FactoryBot.build(:product, name: "👨‍👩‍👦‍👦"*50)
          expect(product).to_not be_valid
        end
        it "is invalid 51 charactors" do
          product = FactoryBot.build(:product, name: "👨‍👩‍👦‍👦"*51)
          expect(product).to_not be_valid
        end
      end
    end
    describe "Registrated Name" do
      before do
        @product.save!
      end
      describe 'in same Upper/Down cases' do
        it "is valid" do
          same_name_product = FactoryBot.build(:product)
          expect(same_name_product).to be_valid
        end
      end
      describe 'in same Upper cases' do
        it "is valid" do
          same_name_product = FactoryBot.build(:product, name: "PHONE-1")
          expect(same_name_product).to be_valid
        end
      end
      describe 'in same down cases' do
        it "is valid" do
          same_name_product = FactoryBot.build(:product, name: "phone-1")
          expect(same_name_product).to be_valid
        end
      end
      describe 'in Japanese,' do
        it "ひらがな and 全角カタカナ is valid" do
          same_name_product_hiragana = FactoryBot.build(:product, name: "ふぉん-1")
          same_name_product_full_width_katakana = FactoryBot.build(:product, name: "フォン-1")
          expect(same_name_product_hiragana).to be_valid
          expect(same_name_product_full_width_katakana).to be_valid
        end
        it "半角カタカナ and 全角カタカナ is valid" do
          same_name_product_half_width_katakana = FactoryBot.build(:product, name: "ﾌｫﾝ-1")
          same_name_product_full_width_katakana = FactoryBot.build(:product, name: "フォン-1")
          expect(same_name_product_half_width_katakana).to be_valid
          expect(same_name_product_full_width_katakana).to be_valid
        end
      end
    end
  end
  describe "Brand Form" do
    describe "filled with word length" do
      it "-1 is invalid(int)" do
        product = FactoryBot.build(:product, brand_id: -1)
        expect(product).to_not be_valid
      end
      it "0 is invalid(int)" do
        product = FactoryBot.build(:product, brand_id: 0)
        expect(product).to_not be_valid
      end
      it { should validate_presence_of(:brand_id) }
      it "1 is valid(int)" do
        product = FactoryBot.build(:product, brand_id: 1)
        expect(product).to be_valid
      end
      it "-1 is invalid(string)" do
        product = FactoryBot.build(:product, brand_id: "-1")
        expect(product).to_not be_valid
      end
      it "0 is invalid(string)" do
        product = FactoryBot.build(:product, brand_id: "0")
        expect(product).to_not be_valid
      end
      it "1 is valid(string)" do
        product = FactoryBot.build(:product, brand_id: "1")
        expect(product).to be_valid
      end
    end
    describe "Charactor Type" do
      context "漢字・ひらがな・カタカナ(全角)" do
        it "is invalid" do
          product = FactoryBot.build(:product, brand_id: "後")
          expect(product).to_not be_valid
        end
      end
      context "半角カタカナ" do
        it "is invalid" do
          product = FactoryBot.build(:product, brand_id: "ﾜｶﾞ")
          expect(product).to_not be_valid
        end
      end
      context "English(Upper/Down Case)" do
        it "is invalid" do
          product = FactoryBot.build(:product, brand_id: "Fr")
          expect(product).to_not be_valid
        end
      end
      context "symbol" do
        it "is invalid" do
          product = FactoryBot.build(:product, brand_id: "▼")
          expect(product).to_not be_valid
        end
      end
      context "Number" do
        it "is valid" do
          product = FactoryBot.build(:product, brand_id: "1")
          expect(product).to be_valid
        end
      end
      context "Emoji" do
        it "is invalid" do
          product = FactoryBot.build(:product, brand_id: "👨‍👩‍👦‍👦")
          expect(product).to_not be_valid
        end
      end
    end
    describe "Registrated brand_id" do
      before do
        @product.save!
      end
      describe 'in same Upper cases' do
        it "is invalid" do
          same_name_product = FactoryBot.build(:product, brand_id: "１")
          expect(same_name_product).to_not be_valid
        end
      end
    end
  end
  describe "Soc Antutu Score" do
    describe "under data-type(string)" do
      describe "Charactor Type" do
        context "漢字・ひらがな・カタカナ(全角)" do
          it "is invalid" do
            product = FactoryBot.build(:product, soc_antutu_score: "後あア")
            expect(product).to_not be_valid
          end
        end
        context "半角カタカナ" do
          it "is invalid" do
            product = FactoryBot.build(:product, soc_antutu_score: "ﾜｶﾞ")
            expect(product).to_not be_valid
          end
        end
        context "English(Upper/Down Case)" do
          it "is invalid" do
            product = FactoryBot.build(:product, soc_antutu_score: "Fr")
            expect(product).to_not be_valid
          end
        end
        context "symbol" do
          it "is invalid" do
            product = FactoryBot.build(:product, soc_antutu_score: "▼")
            expect(product).to_not be_valid
          end
        end
        context "Number" do
          it "(half-width) is invalid" do
            product = FactoryBot.build(:product, soc_antutu_score: "1")
            expect(product).to_not be_valid
          end
          it "(full-width) is invalid" do
            product = FactoryBot.build(:product, soc_antutu_score: "１")
            expect(product).to_not be_valid
          end
        end
        context "Emoji" do
          it "is valid" do
            product = FactoryBot.build(:product, soc_antutu_score: "👨‍👩‍👦‍👦")
            expect(product).to be_valid
          end
        end
      end
    end
    describe "data-type(integer)" do
      context 'harf-width' do
        it "-1 is valid" do
          product = FactoryBot.build(:product, soc_antutu_score: -1)
          expect(product).to_not be_valid
        end
        it "0(zero) is valid" do
          product = FactoryBot.build(:product, soc_antutu_score: 0)
          expect(product).to_not be_valid
        end
        it "1 is valid" do
          product = FactoryBot.build(:product, soc_antutu_score: 1)
          expect(product).to be_valid
        end
      end
      context 'full-width' do
        it "-１ is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: -１)
          expect(product).to_not be_valid
        end
        it "０ is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: ０)
          expect(product).to_not be_valid
        end
        it "１ is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: １)
          expect(product).to_not be_valid
        end
      end
    end
    describe "data-type(float)" do
      context 'harf-width' do
        it "-1.1 is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: -1.1)
          expect(product).to_not be_valid
        end
        it "-1.0 is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: -1.0)
          expect(product).to_not be_valid
        end
        it "-0.1 is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: -0.1)
          expect(product).to_not be_valid
        end
        it "0.0(zero) is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: 0.0)
          expect(product).to_not be_valid
        end
        it "0.1 is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: 0.1)
          expect(product).to_not be_valid
        end
        it "1.0 is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: 1.0)
          expect(product).to_not be_valid
        end
        it "1.1 is invalid" do
          product = FactoryBot.build(:product, soc_antutu_score: 1.0)
          expect(product).to_not be_valid
        end
      end
    end
  end
  describe "Battery Capacity" do
    describe "under data-type(string)" do
      describe "Charactor Type" do
        context "漢字・ひらがな・カタカナ(全角)" do
          it "is invalid" do
            product = FactoryBot.build(:product, battery_capacity: "後あア")
            expect(product).to_not be_valid
          end
        end
        context "半角カタカナ" do
          it "is invalid" do
            product = FactoryBot.build(:product, battery_capacity: "ﾜｶﾞ")
            expect(product).to_not be_valid
          end
        end
        context "English(Upper/Down Case)" do
          it "is invalid" do
            product = FactoryBot.build(:product, battery_capacity: "Fr")
            expect(product).to_not be_valid
          end
        end
        context "symbol" do
          it "is invalid" do
            product = FactoryBot.build(:product, battery_capacity: "▼")
            expect(product).to_not be_valid
          end
        end
        context "Number" do
          it "(harf-width) is valid" do
            product = FactoryBot.build(:product, battery_capacity: "1")
            expect(product).to be_valid
          end
          it "(full-width) is valid" do
            product = FactoryBot.build(:product, battery_capacity: "１")
            expect(product).to be_valid
          end
        end
        context "Emoji" do
          it "is valid" do
            product = FactoryBot.build(:product, battery_capacity: "👨‍👩‍👦‍👦")
            expect(product).to be_valid
          end
        end
      end
    end
    describe "data-type(integer)" do
      context 'harf-width' do
        it "-1 is valid" do
          product = FactoryBot.build(:product, battery_capacity: -1)
          expect(product).to_not be_valid
        end
        it "0(zero) is valid" do
          product = FactoryBot.build(:product, battery_capacity: 0)
          expect(product).to_not be_valid
        end
        it "1 is valid" do
          product = FactoryBot.build(:product, battery_capacity: 1)
          expect(product).to be_valid
        end
      end
      context 'full-width' do
        it "-１ is invalid" do
          product = FactoryBot.build(:product, battery_capacity: -１)
          expect(product).to_not be_valid
        end
        it "０ is invalid" do
          product = FactoryBot.build(:product, battery_capacity: ０)
          expect(product).to_not be_valid
        end
        it "１ is invalid" do
          product = FactoryBot.build(:product, battery_capacity: １)
          expect(product).to_not be_valid
        end
      end
    end
    describe "data-type(float)" do
      context 'harf-width' do
        it "-1.1 is invalid" do
          product = FactoryBot.build(:product, battery_capacity: -1.1)
          expect(product).to_not be_valid
        end
        it "-1.0 is invalid" do
          product = FactoryBot.build(:product, battery_capacity: -1.0)
          expect(product).to_not be_valid
        end
        it "-0.1 is invalid" do
          product = FactoryBot.build(:product, battery_capacity: -0.1)
          expect(product).to_not be_valid
        end
        it "0.0(zero) is invalid" do
          product = FactoryBot.build(:product, battery_capacity: 0.0)
          expect(product).to_not be_valid
        end
        it "0.1 is invalid" do
          product = FactoryBot.build(:product, battery_capacity: 0.1)
          expect(product).to_not be_valid
        end
        it "1.0 is invalid" do
          product = FactoryBot.build(:product, battery_capacity: 1.0)
          expect(product).to_not be_valid
        end
        it "1.1 is invalid" do
          product = FactoryBot.build(:product, battery_capacity: 1.0)
          expect(product).to_not be_valid
        end
      end
    end
  end
  describe "image" do
    describe "File" do
      context "has a GIF format" do
        it "is valid" do
          @product.image = fixture_file_upload("files/image/image_test_3kb.gif")
          expect(@product).to be_valid
        end
      end
      context "has a jpeg format" do
        it "is valid" do
          @product.image = fixture_file_upload("files/image/image_test_3kb.jpeg")
          expect(@product).to be_valid
        end
      end
      context "has a PNG format" do
        it "is valid" do
          @product.image = fixture_file_upload("files/image/image_test_3kb.png")
          expect(@product).to be_valid
        end
      end
      context "has a SVG format" do
        it "is invalid" do
          @product.image = fixture_file_upload("files/image/image_test_3kb.svg")
          expect(@product).to_not be_valid
        end
      end
      context "has a PSD format" do
        it "is invalid" do
          @product.image = fixture_file_upload("files/image/image_test_3kb.psd")
          expect(@product).to_not be_valid
        end
      end
      context "has a BMP format" do
        it "is invalid" do
          @product.image = fixture_file_upload("files/image/image_test_3kb.bmp")
          expect(@product).to_not be_valid
        end
      end
    end
    describe "File size" do
      it "5MB is valid" do
        @product.image = fixture_file_upload("files/image/image_test_5mb.jpeg")
        expect(@product).to be_valid
      end
      it "6MB is invalid" do
        @product.image = fixture_file_upload("files/image/image_test_6mb.jpeg")
        expect(@product).to_not be_valid
      end
    end
  end
end