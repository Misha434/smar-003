require 'rails_helper'

RSpec.describe Brand, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:brand)).to be_valid
  end
  # name の入力がなければ無効な状態であること
  it { should validate_presence_of(:name) }
  # 重複したブランド名なら無効な状態であること 
  it "is invalid with a duplicate Brand name" do
    FactoryBot.create(:brand)
    brand = FactoryBot.build(:brand)
    expect(brand).to_not be_valid
  end
  
  # ブランド名は50文字まで有効であること
  it { should validate_length_of(:name).is_at_most(50) }
  
  #ブランド名が51文字で無効であること
  it "is invalid with a integer data in a brand form" do
    brand = FactoryBot.build(:brand, name: 'a' * 51 )
    brand.valid?
    expect(brand.valid?).to eq false
  end
  
  #ブランド名入力が0文字で無効であること
  it "is invalid without any charactor in a brand form" do
    brand = FactoryBot.build(:brand, name: "" )
    brand.valid?
    expect(brand.valid?).to eq false
  end
  
  #ブランド画像 アップロードが有効であること
  it "is valid with a real image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_logo.png")
    expect(@brand.valid?).to eq true
  end
  
  #gif ブランド画像 アップロードが有効であること
  it "is valid with a GIF image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_3kb.gif")
    expect(@brand.valid?).to eq true
  end

  #jpeg ブランド画像 アップロードが有効であること
  it "is valid with a JPEG image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_3kb.jpeg")
    expect(@brand.valid?).to eq true
  end

  #png ブランド画像 アップロードが有効であること
  it "is valid with a PNG image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_3kb.png")
    expect(@brand.valid?).to eq true
  end

  #svg ブランド画像 アップロードが無効であること
  it "is invalid with a SVG image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_3kb.svg")
    expect(@brand.valid?).to eq false
  end
  
  #psd ブランド画像 アップロードが無効であること
  it "is valid with a PSD image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_3kb.psd")
    expect(@brand.valid?).to eq false
  end

  #bmp ブランド画像 アップロードが無効であること
  it "is valid with a BMP image data" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_3kb.bmp")
    expect(@brand.valid?).to eq false
  end
  
  # 5MBのブランド画像 アップロードは有効であること
  it "is valid with a image data 5MB" do
    @brand = FactoryBot.build(:brand)
    @brand.image = fixture_file_upload("files/image/image_test_5mb.jpeg")
    expect(@brand.valid?).to eq true
  end
  
  # 6MB以上のブランド画像 アップロードは無効であること
  it "is invalid with a image data over 6MB" do
    brand = FactoryBot.build(:brand)
    brand.image = fixture_file_upload("files/image/image_test_6mb.jpeg")
    expect(brand.valid?).to eq false
  end
end
