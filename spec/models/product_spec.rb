require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @brand = FactoryBot.create(:brand)
  end
  
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:product, brand_id: @brand.id)).to be_valid
  end
  
  it { should validate_presence_of(:name) }
  
  it { should validate_presence_of(:soc_antutu_score) }
    
  it { should validate_presence_of(:battery_capacity) }  
  
  it { should validate_presence_of(:brand_id) }
  
  #製品画像 アップロードが有効であること
  it "is valid with a real image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_logo.png")
    expect(@product.valid?).to eq true
  end
  
  #gif 製品画像 アップロードが有効であること
  it "is valid with a GIF image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_3kb.gif")
    expect(@product.valid?).to eq true
  end

  #jpeg 製品画像 アップロードが有効であること
  it "is valid with a JPEG image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_3kb.jpeg")
    expect(@product.valid?).to eq true
  end

  #png 製品画像 アップロードが有効であること
  it "is valid with a PNG image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_3kb.png")
    expect(@product.valid?).to eq true
  end

  #svg 製品画像 アップロードが無効であること
  it "is invalid with a SVG image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_3kb.svg")
    expect(@product.valid?).to eq false
  end
  
  #psd 製品画像 アップロードが無効であること
  it "is valid with a PSD image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_3kb.psd")
    expect(@product.valid?).to eq false
  end

  #bmp 製品画像 アップロードが無効であること
  it "is valid with a BMP image data" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_3kb.bmp")
    expect(@product.valid?).to eq false
  end
  
  # 5MBの製品画像 アップロードは有効であること
  it "is valid with a image data 5MB" do
    @product = FactoryBot.build(:product)
    @product.image = fixture_file_upload("files/image/image_test_5mb.jpeg")
    expect(@product.valid?).to eq true
  end
  
  # 6MB以上の製品画像 アップロードは無効であること
  it "is invalid with a image data over 6MB" do
    brand = FactoryBot.build(:product)
    brand.image = fixture_file_upload("files/image/image_test_6mb.jpeg")
    expect(brand.valid?).to eq false
  end
  
end
