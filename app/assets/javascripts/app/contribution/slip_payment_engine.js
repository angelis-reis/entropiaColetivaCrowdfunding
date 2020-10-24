App.addChild('SlipPaymentEngine', {
  el: '#slip-payment-engine',

  activate: function(){
    var that = this;
    $.get(this.$("#engine").data('path')).success(function(data){
      that.$("#engine").html(data);

      $('#catarse_iugu_form_slip').unbind();
    });
  },
});

