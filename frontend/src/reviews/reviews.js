import "./reviews.css";

// Image size Varidation
$("#review_image").on("change", () => {
  const sizeInMegaBytes = this.files[0].size / 1024 / 1024;
  if (sizeInMegaBytes > 5) {
    alert("Maximum file size is 5MB. Please choose a smaller file.");
    $("#review_image").val("");
  }
});

// Product form Filtered selected Brand
$(() => {
  const selectField = $(".js-select_field").on("change", () => {
    // eslint-disable-next-line camelcase
    const brand_id = selectField.val();
    $.ajax({
      type: "GET",
      url: "/reviews/picks",
      // eslint-disable-next-line camelcase
      data: { brand_id },
      dataType: "json"
    }).done(data => {
      $("#review_product_id")
        .children()
        .remove();
      $(data.product).each(i => {
        $(".js-receive_field").removeAttr("disabled");
        $(".js-receive_field").append(
          $("<option>")
            .val(`${data.product[i].id}`)
            .text(`${data.product[i].name}`)
        );
      });
    });
  });
});
