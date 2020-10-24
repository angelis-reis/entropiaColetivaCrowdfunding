namespace :mails do
	
	desc 'Check if 24 hours left before deadline'
	task day_before_expire: :environment do
		Project.includes(:payments).expiring_in_day.each do |p|
			p.payments.select('DISTINCT user_id').each do |u|
				# TODO: fix sidekiq async
				ExpiresInDaySenderWorker.new.perform(p, u.user.email)
			end
			p.update_attribute(:day_before_mail_sent, true)
		end
	end

	desc 'Check if 48 hours left before deadline'
	task two_days_before_expire: :environment do
		Project.includes(:notifications).expiring_in_two_days.each do |p|
			p.notifications.select('DISTINCT user_id').each do |n|
				# TODO: fix sidekiq async
				ExpiresInTwoDaysSenderWorker.new.perform(p, n.user.email)
			end
			p.update_attribute(:two_days_before_mail_sent, true)
		end
	end

	desc 'Checks if goal met'
	task goal_met: :environment do
		puts 'STARTED'
		Project.includes(:payments, :contributions).goal_met_not_emailed.each do |p|
			p.payments.each do |u|
				# TODO: fix sidekiq async
				GoalMetMailSenderWorker.new.perform(p, u.user.email)
			end
			p.update_attribute(:emailed_about_goal_met, true)
		end
	end

	desc 'test'
	task :test => :environment do
		puts 'Sending started'
		UserMailer.test_message('fahrenhei7lt@gmail.com').deliver
		puts 'Sending FINISHED'
	end

end