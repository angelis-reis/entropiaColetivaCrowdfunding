App.addChild('Payment', {
  el: '#payment-engines',

  activate: function(){
    var that = this;
    $.get(this.$("#engine").data('path')).success(function(data){
      that.$("#engine").html(data);

      var form = document.getElementById('catarse_iugu_form_slip');
      
      form.addEventListener('submit', function(event) {
        event.preventDefault();

        var contributionId = document.getElementById('contribution_id');
        var currentPath = window.location.pathname;
        var pathToRedirect = currentPath.replace('edit', 'slip_payment');
        
        window.location.href = pathToRedirect;
      }); 
    });
  },

  show: function(){
    this.$el.slideDown('slow');
  },

  hide: function() {
    this.$el.hide();
  }
});

