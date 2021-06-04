module ApplicationHelper
  def product_image_default(product)
    if product.image.attached?
      link_to image_tag(product.image, width: "75px",
      class: "img-fluid"), product_path(product)
    else
      link_to image_tag("product_no_image.jpeg",
      width: "75px", class: "img-fluid"), product_path(product)
    end
  end
  
  # def delete_review
  #   if current_user?(@review.user) == review.user
  #     link_to review, method: :delete, data:{confirm: "You sure?"} do
  #       i.fa.fa-trash-o.fa-xs
  #     end
  #   end
  # end
  
  # def full_title(page_title = '')
  #   base_title = "SmaR"
  #   if page_title.empty?
  #     base_title
  #   else
  #     page_title + " - " + base_title
  #   end
  # end
end