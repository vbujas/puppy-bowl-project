var sourceSwap = function () {
  var $this = $(this);
  var newSource = $this.data('alt-src');
  $this.data('alt-src', $this.attr('src'));
  $this.attr('src', newSource);
}

$(function () {
  $('#create_team').hover(sourceSwap, sourceSwap);
  $('.draftbutton').hover(sourceSwap, sourceSwap);
  $('#done_draft').hover(sourceSwap, sourceSwap);
  $('#vote_btn').hover(sourceSwap, sourceSwap);
  $('#done_green').hover(sourceSwap, sourceSwap);
});
