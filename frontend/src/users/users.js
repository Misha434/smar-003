import "./users.css";

// Disabled Submit button without
$(() => {
  $("#signup--submit").prop("disabled", true);
  $("#agreement").click(function confirmCheckBox() {
    if ($(this).prop("checked") === false) {
      $("#signup--submit").prop("disabled", true);
    } else {
      $("#signup--submit").prop("disabled", false);
    }
  });
});
