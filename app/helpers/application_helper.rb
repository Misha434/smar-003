module ApplicationHelper
  def product_image_default(product)
    if product.image.attached?
      link_to image_pack_tag(product.image, width: "75px",
      class: "img-fluid"), product_path(product)
    else
      link_to image_pack_tag("product_no_image.jpeg",
      width: "75px", class: "img-fluid"), product_path(product)
    end
  end
  
  def full_title(page_title = '')
    base_title = "SmaR"
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end
end