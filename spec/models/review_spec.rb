require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @brand = FactoryBot.create(:brand)
    @user = FactoryBot.create(:user)
    @product = FactoryBot.create(:product, brand_id: @brand.id)

    @review = FactoryBot.create(:review, user_id: @user.id, \
                                         product_id: @product.id)
  end

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(@review).to be_valid
  end

  # contentの入力がなければ無効な状態であること
  it { should validate_presence_of(:content) }

  # product_idの入力がなければ無効な状態であること
  it { should validate_presence_of(:product_id) }

  # contentの入力が140文字までであれば有効な状態であること
  it { should validate_length_of(:content).is_at_most(140) }

  # contentの入力が1文字であれば有効な状態であること
  it { should validate_length_of(:content).is_at_least(1) }

  # contentの入力が141文字であれば無効な状態であること
  it "has an invalid review with an 141 charactor" do
    @review = FactoryBot.build(:review, content: "a" * 141)
    expect(@review).to_not be_valid
  end

  # レビュー画像 アップロードが有効であること
  it "is valid with a real image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_logo.png")
    expect(@review.valid?).to eq true
  end

  # gif レビュー画像 アップロードが有効であること
  it "is valid with a GIF image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_3kb.gif")
    expect(@review.valid?).to eq true
  end

  # jpeg レビュー画像 アップロードが有効であること
  it "is valid with a JPEG image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_3kb.jpeg")
    expect(@review.valid?).to eq true
  end

  # png レビュー画像 アップロードが有効であること
  it "is valid with a PNG image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_3kb.png")
    expect(@review.valid?).to eq true
  end

  # svg レビュー画像 アップロードが無効であること
  it "is invalid with a SVG image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_3kb.svg")
    expect(@review.valid?).to eq false
  end

  # psd レビュー画像 アップロードが無効であること
  it "is invalid with a PSD image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_3kb.psd")
    expect(@review.valid?).to eq false
  end

  # bmp レビュー画像 アップロードが無効であること
  it "is invalid with a BMP image data" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_3kb.bmp")
    expect(@review.valid?).to eq false
  end

  # 5MBのレビュー画像 アップロードは有効であること
  it "is valid with a image data 5MB" do
    @review = FactoryBot.build(:review)
    @review.image = fixture_file_upload("files/image/image_test_5mb.jpeg")
    expect(@review.valid?).to eq true
  end

  # 6MB以上のレビュー画像 アップロードは無効であること
  it "is invalid with a image data over 6MB" do
    review = FactoryBot.build(:review)
    review.image = fixture_file_upload("files/image/image_test_6mb.jpeg")
    expect(review.valid?).to eq false
  end
end
