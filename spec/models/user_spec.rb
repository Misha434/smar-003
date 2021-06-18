require 'rails_helper'

RSpec.describe User, type: :model do
  # Modified Format Start
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
  # Modified Format End
  
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 名前、メール、パスワードがあれば有効な状態であること
  it "is valid with a name, email and password" do
    user = User.new(
      name: "John",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_valid
  end

  # 名前の入力がなければ無効な状態であること
  it "is invalid without name" do
    user = FactoryBot.build(:user, name: "")
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

 

  

  # 大文字で入力されたemailが小文字で登録されること
  it "is invalid email with 255 characters" do
    pending("something else getting finished")
    this_should_not_get_executed
  end

  # 大小文字混在したemailで登録済みEmailと一致したら無効になること
  it "x" do
    pending("something else getting finished")
    this_should_not_get_executed
    # user = FactoryBot.build(:user)
    # user.email && User.find_by(params[:email])
  end

  # Passwordの入力がなければ無効な状態であること
  it "is invalid without Password" do
    user = FactoryBot.build(:user, password: "")
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  # Password Confirmationの入力がなければ無効な状態であること
  it "is invalid without Password Confirmation" do
    user = FactoryBot.build(:user, password_confirmation: "")
    user.valid?
    expect(user.errors[:password_confirmation]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  # パスワードとパスワード確認に異なる値が入力されたら無効であること
  it "is invalid with a diffirent Password from Password Confirmation" do
    user = FactoryBot.build(:user, password_confirmation: "passwor")
    user.valid?
    expect(user.password_confirmation).to_not eq user.password
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  # スペルが同じでパスワード(小文字)・パスワード確認(大文字)が入力されたら無効であること
  it "is invalid with same Passwords what is UPPER or down cases" do
    user = FactoryBot.build(:user, password_confirmation: "PASSWORD")
    user.valid?
    expect(user.password_confirmation).to_not eq user.password
  end

  # Passwordの入力が５文字ならば無効な状態であること
  it "is invalid with a Password in 5 charactors" do
    user = FactoryBot.build(:user, password: 'a' * 5, \
                                   password_confirmation: "aaaaa")
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end
end
