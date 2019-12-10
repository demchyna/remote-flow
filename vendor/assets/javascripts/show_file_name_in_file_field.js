$( document ).on('turbolinks:load', function() {
  $('#file').on("change", function() {
    if ($('#file')[0].files[0].name.length > 15) {
      var file_name = $('#file')[0].files[0].name.split("").slice(0, 15).join("") + "...";
    }
    else {
      var file_name = $('#file')[0].files[0].name;
    }
    $('span.file-custom').text(file_name);
    $('span.file-custom').addClass("file-custom-file-chosen");
  });
});