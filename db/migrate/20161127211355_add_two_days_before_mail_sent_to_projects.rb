class AddTwoDaysBeforeMailSentToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :two_days_before_mail_sent, :boolean, default: false
  end
end
