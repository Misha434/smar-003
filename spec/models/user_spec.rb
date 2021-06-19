require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  describe 'All Forms filled-out (Name, Email, Password, Confirm Password)' do
    it 'is a valid' do
      expect(@user).to be_valid
    end
    it 'with an attached image is a valid' do
      @user.avatar = fixture_file_upload("files/image/image_test_logo.png")
      expect(@user).to be_valid
    end
  end
  describe "Create Admin User" do
    it "is valid" do
      @user.admin = true
      expect(@user).to be_valid
    end
  end
  describe "Name Form" do
    describe "filled with word length" do
      context "is 0(zero)" do
        it "is invalid" do
          user = FactoryBot.build(:user, name: "")
          expect(user).to_not be_valid
        end
      end
      context "is 1" do
        it "is valid" do
          user = FactoryBot.build(:user, name: "a")
          expect(user).to be_valid
        end
      end
      context "is 140" do
        it "is valid" do
          user = FactoryBot.build(:user, name: "Adolph Blaine Charles David Earl Frederick Gerald Hubert Irvin John Kenneth Lloyd Martin  Oliver Paul Quincy Randolph Sherman Thomas, Senior")
          expect(user).to be_valid
        end
      end
      context "is 141" do
        it "is invalid" do
          user = FactoryBot.build(:user, name: "Adolphe Blaine Charles David Earl Frederick Gerald Hubert Irvin John Kenneth Lloyd Martin  Oliver Paul Quincy Randolph Sherman Thomas, Senior")
          expect(user).to_not be_valid
        end
      end
    end
  end
  describe "Charactor Type" do
    context "漢字・ひらがな・カタカナ(全角)" do
      it "is valid" do
        user = FactoryBot.build(:user, name: "吾輩は猫である。名前はまだ無い。どこで生れたか見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕まえて")
        expect(user).to be_valid
      end
    end
    context "半角カタカナ" do
      it "is valid" do
        user = FactoryBot.build(:user, name: "ﾜｶﾞﾊｲﾊﾈｺﾃﾞｱﾙ｡ﾅﾏｴﾊﾏﾀﾞﾅｲ｡ﾄﾞｺﾃﾞｳﾏﾚﾀｶｹﾝﾄｳｶﾞﾂｶﾇ｡ﾅﾝﾃﾞﾓｳｽｸﾞﾗｲｼﾞﾒｼﾞﾒｼﾀﾄｺﾛﾃﾞﾆｬｰﾆｬｰﾅｲﾃｲﾀｺﾄﾀﾞｹﾊｷｵｸｼﾃｲﾙ｡ﾜｶﾞﾊｲﾊｺｺﾃﾞﾊｼﾞﾒﾃﾆﾝｹﾞﾝﾄｲｳﾓﾉｦﾐﾀ｡ｼｶﾓｱﾄﾃﾞｷｸﾄｿﾚﾊｼｮｾｲﾄ")
        expect(user).to be_valid
      end
    end
    context "English(Upper/Down Case)" do
      it "is valid" do
        user = FactoryBot.build(:user, name: "From fairest creatures we desire increase, That thereby beauty's rose might never die, But as the riper should by time decease, His tender h")
        expect(user).to be_valid
      end
    end
    context "symbol" do
      it "is valid" do
        user = FactoryBot.build(:user, name: "。,.・:;?!_〃々〆―‐/～()〔〕{}〈〉《》「」『』【】()〔〕[]{}〈〉《》「」『』【】-±×÷≠<>≦≧∞∴♂♀°′″℃\$￠￡%#&*@§☆★○×●◎◇◆□■△▲▽▼※〒→←↑↓∇∵Å‰†‡ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξ")
        expect(user).to be_valid
      end
    end
    context "Number" do
      it "is valid" do
        user = FactoryBot.build(:user, name: "88991646493833403４５３１７５１９０２４８７５１０４３６５１８２７４６１８２5583930475933309375106426114774904555295339660573207200961918790742222502268864235692475344959")
        expect(user).to be_valid
      end
    end
    context "Emoji" do
      it "is valid" do
        user = FactoryBot.build(:user, name: "👨‍👩‍👦‍👦"*140)
        expect(user).to be_valid
      end
      it "is invalid 141 charactors" do
        user = FactoryBot.build(:user, name: "👨‍👩‍👦‍👦"*141)
        expect(user).to_not be_valid
      end
    end
  end
  describe "Registrated Name" do
    it "is valid" do
      @user.save!
      same_name_user = FactoryBot.build(:user, email: "test1@example.com")
      expect(same_name_user).to be_valid
    end
  end
  describe "Email Form" do
    describe "filled with word length" do
      it { is_expected.to validate_presence_of :email }
      it { should_not validate_length_of(:email).is_at_least(2) }
      it do
        should validate_length_of(:email).
        is_at_least(3).is_at_most(254)
      end
      it { should_not validate_length_of(:email).is_at_most(255) }
    end
    describe "included Charactor Type" do
      context "漢字" do
        it "is invalid" do
          user = FactoryBot.build(:user, email: "test亜@example.com")
          expect(user).to_not be_valid
        end
      end
      context "ひらがな" do
        it "is invalid" do
          user = FactoryBot.build(:user, email: "testあ@example.com")
          expect(user).to_not be_valid
        end
      end
      context "全角カタカナ" do
        it "is invalid" do
          user = FactoryBot.build(:user, email: "testア@example.com")
          expect(user).to_not be_valid
        end
      end
      context "半角カタカナ" do
        it "is invalid" do
          user = FactoryBot.build(:user, email: "ﾜtest@example.com")
          expect(user).to_not be_valid
        end
      end
      context "English" do
        it "Upper Case is invalid" do
          user = FactoryBot.build(:user, email: "TEST@EXAMPLE.COM")
          expect(user).to_not be_valid
        end
        it "Down Case is valid" do
          user = FactoryBot.build(:user)
          expect(user).to be_valid
        end
      end
      context "symbol" do
        it "is valid" do
          user = FactoryBot.build(:user, email: "test1@example.com")
          expect(user).to be_valid
        end
        it "others are invalid" do
          user = FactoryBot.build(:user, email: "test※@example.com")
          expect(user).to_not be_valid
        end
      end
      context "Number" do
        it "full-width is invalid" do
          user = FactoryBot.build(:user, email: "test１@example.com")
          expect(user).to be_valid
        end
        it "harf-width is invalid" do
          user = FactoryBot.build(:user, email: "test1@example.com")
          expect(user).to_not be_valid
        end
      end
      context "space" do
        it "blank(beginning of sentence) is invalid" do
          user = FactoryBot.build(:user, email: " test@example.com")
          expect(user).to_not be_valid
        end
        it "blank(in the sentences) is invalid" do
          user = FactoryBot.build(:user, email: "te st@example.com")
          expect(user).to_not be_valid
        end
        it "blank(end of sentences) is invalid" do
          user = FactoryBot.build(:user, email: "test@example.com ")
          expect(user).to_not be_valid
        end
      end
      context "Emoji" do
        it "is invalid" do
          user = FactoryBot.build(:user, email: "test👨‍👩‍👦‍👦@example.com")
          expect(user).to_not be_valid
        end
      end
    end
    describe "Registrated Email" do
      before do
        @user.save!
      end
      it "is invalid" do
        same_email_user = FactoryBot.build(:user)
        expect(same_email_user).to_not be_valid
      end
      it "mixed Upper/Down cases is invalid" do
        same_email_user = FactoryBot.build(:user, email: "teSt@eXamPle.com")
        expect(same_email_user).to_not be_valid
      end
    end
    describe "Password Form" do
      describe "filled with word length" do
        it { is_expected.to validate_presence_of :password }
        it { should_not validate_length_of(:password).is_at_least(5) }
        it do
          should validate_length_of(:password).
          is_at_least(6).is_at_most(128)
        end
        it { should_not validate_length_of(:password).is_at_most(129) }
      end
      describe "included Charactor Type" do
        context "漢字" do
          it "is invalid" do
            user = FactoryBot.build(:user, password: "password漢")
            expect(user).to_not be_valid
          end
        end
        context "ひらがな" do
          it "is invalid" do
            user = FactoryBot.build(:user, password: "passwordあ")
            expect(user).to_not be_valid
          end
        end
        context "全角カタカナ" do
          it "is invalid" do
            user = FactoryBot.build(:user, password: "passwordカ")
            expect(user).to_not be_valid
          end
        end
        context "半角カタカナ" do
          it "is invalid" do
            user = FactoryBot.build(:user, password: "ﾜpassword")
            expect(user).to_not be_valid
          end
        end
        context "English" do
          it "Upper Case is invalid" do
            user = FactoryBot.build(:user, password: "PASSWORD")
            expect(user).to be_valid
          end
          it "Down Case is valid" do
            user = FactoryBot.build(:user, email: "test1@example.com", password: "password")
            expect(user).to be_valid
          end
        end
        context "symbol" do
          it "is valid" do
            user = FactoryBot.build(:user, password: "password/")
            expect(user).to be_valid
          end
          it "others are invalid" do
            user = FactoryBot.build(:user, password: "password*&")
            expect(user).to_not be_valid
          end
        end
        context "Number" do
          it "full-width is invalid" do
            user = FactoryBot.build(:user, password: "password1234567890")
            expect(user).to be_valid
          end
          it "harf-width is invalid" do
            user = FactoryBot.build(:user, password: "password１２３４５６７８９０")
            expect(user).to_not be_valid
          end
        end
        context "space" do
          it "blank(beginning of sentence) is invalid" do
            user = FactoryBot.build(:user, password: " password")
            expect(user).to_not be_valid
          end
          it "blank(in the sentences) is invalid" do
            user = FactoryBot.build(:user, password: "pa ssword")
            expect(user).to_not be_valid
          end
          it "blank(end of sentences) is invalid" do
            user = FactoryBot.build(:user, password: "password ")
            expect(user).to_not be_valid
          end
        end
        context "Emoji" do
          it "is invalid" do
            user = FactoryBot.build(:user, password: "👨‍👩‍👦‍👦password")
            expect(user).to_not be_valid
          end
        end
      end
      describe "Registrated Password" do
        before do
          @user.save!
        end
        it "is invalid" do
          same_password_user = FactoryBot.build(:user)
          expect(same_password_user).to_not be_valid
        end
        it "mixed Upper/Down cases is invalid" do
          same_password_user = FactoryBot.build(:user, password: "pAssWOrd")
          expect(same_password_user).to_not be_valid
        end
      end
    end
    describe "Password Confirm Form" do
      it { should validate_confirmation_of(:password) }
      describe "with blank" do
        it "is invalid" do
          user = FactoryBot.build(:user, password_confirmation: "")
          expect(user).to_not be_valid
        end
      end
      describe "included a nagetive password" do
        it "is invalid" do
          user = FactoryBot.build(:user, password_confirmation: "passwor")
          expect(user).to_not be_valid
        end
        it "(with Upper case) is invalid" do
          user = FactoryBot.build(:user, password_confirmation: "PASSWORD")
          expect(user).to_not be_valid
        end
        it "(with space) is invalid" do
          user = FactoryBot.build(:user, password_confirmation: " password")
          expect(user).to_not be_valid
        end
      end
    end
    describe "Avatar" do
      describe "File" do
        context "has a GIF format" do
          it "is valid" do
            @user.avatar = fixture_file_upload("files/image/image_test_3kb.gif")
            expect(@user).to be_valid
          end
        end
        context "has a GIF format" do
          it "is valid" do
            @user.avatar = fixture_file_upload("files/image/image_test_3kb.jpeg")
            expect(@user).to be_valid
          end
        end
        context "has a PNG format" do
          it "is valid" do
            @user.avatar = fixture_file_upload("files/image/image_test_3kb.png")
            expect(@user).to be_valid
          end
        end
        context "has a SVG format" do
          it "is invalid" do
            @user.avatar = fixture_file_upload("files/image/image_test_3kb.svg")
            expect(@user).to_not be_valid
          end
        end
        context "has a PSD format" do
          it "is invalid" do
            @user.avatar = fixture_file_upload("files/image/image_test_3kb.psd")
            expect(@user).to_not be_valid
          end
        end
        context "has a BMP format" do
          it "is invalid" do
            @user.avatar = fixture_file_upload("files/image/image_test_3kb.bmp")
            expect(@user).to_not be_valid
          end
        end
      end
      describe "File size" do
        it "5MB is valid" do
          @user.avatar = fixture_file_upload("files/image/image_test_5mb.jpeg")
          expect(@user).to be_valid
        end
        it "6MB is invalid" do
          @user.avatar = fixture_file_upload("files/image/image_test_6mb.jpeg")
          expect(@user).to_not be_valid
        end
      end
    end
  end
end