job_type :rbenv_rake, %Q{export PATH=/home/ubuntu/.rbenv/shims:/home/ubuntu/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && bundle exec rake :task --silent :output }

every 15.minutes do
	rbenv_rake "mails:day_before_expire", environment: 'development'
end

every 20.minutes do
	rbenv_rake "mails:two_days_before_expire", environment: 'development'
end

every 10.minutes do
	rbenv_rake "mails:goal_met", environment: 'development'
end
