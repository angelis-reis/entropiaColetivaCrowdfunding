class ThanksContributionSenderWorker
  include Sidekiq::Worker

  def perform(contribution)
  	ProjectMailer.thanks_contribution(contribution).deliver
  end
end
