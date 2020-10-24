class ExpiresInTwoDaysSenderWorker
  include Sidekiq::Worker

  def perform(project, email)
  	ProjectMailer.remind_48_message(project, email).deliver
  end
end
