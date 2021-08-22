import "./reviews.css";

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
