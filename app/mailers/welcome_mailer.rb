class WelcomeMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  default from: "contato@entropiacoletiva.com"

  def welcome(email)
    roadie_mail to: email, subject: "Bem vindo(a) à Entropia Coletiva! :)"
  end
end
