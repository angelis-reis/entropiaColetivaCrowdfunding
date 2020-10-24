class ExpiresInDaySenderWorker
  include Sidekiq::Worker

  def perform(project, email)
  	ProjectMailer.remind_24_message(project, email).deliver
  end
end
