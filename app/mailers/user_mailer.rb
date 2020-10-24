class UserMailer < ActionMailer::Base
  default from: 'contato@entropiacoletiva.com'

  def greeting_message(user)
  	@user = user
    mail to: @user.email, subject: "Seja bem-vindo"
  end

  def test_message(email)
  	mail to: email, subject: 'Test test'
  end
end