import "./brands.css";

// brand image_size varidation
$("#brand_image").bind("change", () => {
  const sizeInMegaBytes = this.files[0].size / 1024 / 1024;
  if (sizeInMegaBytes > 5) {
    alert("Maximum file size is 5MB. Please choose a smaller file.");
    $("#brand_image").val("");
  }
});
