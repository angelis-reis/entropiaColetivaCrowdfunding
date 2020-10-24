class AddEmailedAboutGoalMetToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :emailed_about_goal_met, :boolean, default: false
  end
end
