function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  // return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
  popup_window = window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
  // if(popup_window.opener) {
    // window.opener.location.reload(true);
    // window.close()
    // setInterval(function(){ popup_window.close(); }, 10000);
  // }
}

jQuery(function($) {
  $("a.popup").click(function(e) {
    $('#sign-up').modal('toggle');
    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation(); return false;
  });
});
