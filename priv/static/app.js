$('#add-url').on('click', function(e) {
  e.preventDefault();
  $('#url-inputs').append('<input type="text" name="urls[]" class="url">');
});
$('form').on('submit', function(e) {
  e.preventDefault();
  $.post("/", $(this).serialize(), function(response) {
    $('#result').html('<pre>' + JSON.stringify(response, null, 2) + '</pre>');
    $('html, body').animate({
      scrollTop: $('#result').offset().top
    }, 200);
  });
});
