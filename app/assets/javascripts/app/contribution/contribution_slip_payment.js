App.addChild('SlipPaymentDataForm', _.extend({
  el: 'form#slip_payment_data_form',

  events: {
    'blur input' : 'checkInput',
    'change #contribution_address_state' : 'checkInput',
    'change #contribution_country_id' : 'onCountryChange',
    'click #generate_slip' : 'generateSlip',
  },

  generateSlip: function(){
    if(this.validate()) {
      this.updateContributionAndGenerateSlipPayment();
      this.$errorMessage.hide();
    } else {
      this.$errorMessage.slideDown('slow');
    }
  },

  onCountryChange: function(){
    if(this.$country.val() == '36'){
      this.nationalAddress();
    }
    else{
      this.internationalAddress();
    }
  },

  internationalAddress: function(){
    this.$state.data('old_value', this.$state.val());
    this.$state.val('outro / other');
    this.makeFieldsOptional();
  },

  makeFieldsRequired: function(){
    this.$('[data-required-in-brazil]').prop('required', 'required');
    this.$('[data-required-in-brazil]').parent().removeClass('optional').addClass('required');
  },

  makeFieldsOptional: function(){
    this.$('[data-required-in-brazil]').prop('required', false);
    this.$('[data-required-in-brazil]').parent().removeClass('required').addClass('optional');
  },

  nationalAddress: function(){
    if(this.$state.data('old_value')){
      this.$state.val(this.$state.data('old_value'));
    }
    this.makeFieldsRequired();
  },

  activate: function(){
    this.$country = this.$('#contribution_country_id');
    if(this.$country.val() === ''){
      this.$country.val('36');
    }
    this.$state = this.$('#contribution_address_state');
    this.$errorMessage = this.$('#error-message');
    this.setupForm();
    this.onCountryChange();
  },

  updateContributionAndGenerateSlipPayment: function(){
    var url = this.$el.attr('action');
    var contribution_data = {
      anonymous: this.$('#contribution_anonymous').is(':checked'),
      country_id: this.$('#contribution_country_id').val(),
      payer_name: this.$('#contribution_payer_name').val(),
      payer_email: this.$('#contribution_payer_email').val(),
      payer_document: this.$('#contribution_payer_document').val(),
      address_street: this.$('#contribution_address_street').val(),
      address_number: this.$('#contribution_address_number').val(),
      address_complement: this.$('#contribution_address_complement').val(),
      address_neighbourhood: this.$('#contribution_address_neighbourhood').val(),
      address_zip_code: this.$('#contribution_address_zip_code').val(),
      address_city: this.$('#contribution_address_city').val(),
      address_state: this.$('#contribution_address_state').val(),
      address_phone_number: this.$('#contribution_address_phone_number').val()
    };

    $.post(url, {
      _method: 'put',
      contribution: contribution_data
    }).done(function() {
      var slipPaymentForm = document.getElementById('catarse_iugu_form_slip');
      slipPaymentForm.submit();
    });
  },

  generateSlipPayment: function() {
    var slipPaymentForm = document.getElementById('catarse_iugu_form_slip');
    slipPaymentForm.submit();
  }

}, Skull.Form));

