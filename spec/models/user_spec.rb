require 'rails_helper'

RSpec.describe User, type: :model do
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
      password_confirmation: "password",
    )
    expect(user).to be_valid
  end
  
  # 名前の入力がなければ無効な状態であること
  it "is invalid without name" do
    user = FactoryBot.build(:user, name: "")
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end
  
  # emailの入力がなければ無効な状態であること
  it { is_expected.to validate_presence_of :email }

  # emailの文字数が(最小)3文字ならば有効であること
  it { should validate_length_of(:email).is_at_least(3) }
  
  # emailの文字数が(最大) 254文字ならば有効であること
  it { should validate_length_of(:email).is_at_most(254) }
  
  # emailの文字数が(最小)2文字ならば無効であること
  it { should_not validate_length_of(:email).is_at_least(2) }
  # emailの文字数が(最大)255文字ならば無効であること
  it { should_not validate_length_of(:email).is_at_most(255) }

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
    user = FactoryBot.build(:user, password: 'a' * 5 , \
    password_confirmation: "aaaaa")
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end
end
