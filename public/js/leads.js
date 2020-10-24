$(function setupLeads() {
  $('[data-submit]').submit(submitAsync);
  var spinner = $('#spinner').hide()
      messageContainer = $('#message').hide();

  function submitAsync(ev, form, method) {
    ev.preventDefault();

    var form = $(this);
    form.hide();
    spinner.show();

    $.ajax({
      url: form.attr("action"),
      method: form.attr("method"),
      data: form.serialize()
    })
    .done(showMessage('E-mail cadastrado! Entraremos em contato com mais novidades!'))
    .fail(showMessage('Houve um problema ao enviar seu email, nossa equipe já foi avisada.'))
    .always(hideSpinner);
  }

  function showMessage(message) {
    return function delayedShowMessage() {
      messageContainer.text(message).show();
    };
  }

  function hideSpinner() {
    spinner.hide();
  }
});
