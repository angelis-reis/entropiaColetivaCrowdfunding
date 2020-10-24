class NewPostMailSenderWorker
  include Sidekiq::Worker

  def perform(post, email, project)
  	ProjectMailer.new_post_message(post, email,project).deliver
  end
end
