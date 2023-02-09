// Remove ugly #_=_ string from URL when using Facebook OmniAuth
$(document).ready(function () {
  if (window.location.href.indexOf('#_=_') > 0) {
    window.location = window.location.href.replace(/#.*/, '');
}});
