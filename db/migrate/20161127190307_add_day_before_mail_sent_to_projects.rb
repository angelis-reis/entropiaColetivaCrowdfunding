class AddDayBeforeMailSentToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :day_before_mail_sent, :boolean, default: false
  end
end
