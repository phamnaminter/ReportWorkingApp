$('.edit_comment').click(function() {
  var comment_block = $(this).closest('.commentText'),
      hidden_comment = comment_block.find('#hidden_comment').val(),
      comment_id = comment_block.find('#comment_id').val();

  $('.comment_modal_text').val(hidden_comment);
  $('#myModal').find('#comment_id').val(comment_id);
});
