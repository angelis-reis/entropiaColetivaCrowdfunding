class ProjectMailer < ActionMailer::Base
  default from: 'contato@entropiacoletiva.com'

  def approved_message(project)
    @project = project
    mail to: @project.user.email, subject: 'Seu projeto na Entropia Coletiva foi aprovado.'
  end

  def new_post_message(post, email, project)
    @post = post
    @project = project
  	mail to: email, subject: "Novo diário de laboratório #{@post.title} publicado!"
  end

  def thanks_contribution(contribution)
    @contribution = contribution
  	mail to: @contribution.user.email, subject: 'Obrigado pelo seu apoio!'
  end

  def remind_24_message(project, email)
    @project = project
  	mail to: email, subject: "A campanha #{@project.name} finaliza em 1 dia! "
  end

  def remind_48_message(project, email)
    @project = project
    mail to: email, subject: "Faltam apenas 2 dias para a campanha #{@project.name} acabar. "
  end

  def goal_met(project, email)
    @project = project
    mail to: email, subject: "#{@project.name} atingiu a meta!"
  end
end