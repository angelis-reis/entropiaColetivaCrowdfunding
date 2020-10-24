class GoalMetMailSenderWorker
  include Sidekiq::Worker

  def perform(project, email)
  	ProjectMailer.goal_met(project, email).deliver
  end
end
