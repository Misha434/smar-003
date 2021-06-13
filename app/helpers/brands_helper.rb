module BrandsHelper
  def logo_image_default(brand)
    if brand.image.attached?
      link_to image_tag(brand.image, width: "75px",
                                     class: "img-fluid"), brand_path(brand)
    else
      link_to image_tag("brand_default_logo.png",
                        width: "75px", class: "img-fluid"), brand_path(brand)
    end
  end
end
