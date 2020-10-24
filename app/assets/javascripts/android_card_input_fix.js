$(document).ready(function() {
  var ua = navigator.userAgent.toLowerCase();
  var isAndroid = ua.indexOf("android") > -1;
  if (isAndroid) {
    $("input.credit_card_expiration").mask("99/99");
    $("input.credit_card_cvv").mask("9999");
  }
});