class ProjectsForHome < Project
  self.table_name = 'projects_for_home'
  #self.primary_key = "id"
  has_one :project_total, foreign_key: :project_id
  belongs_to :user
  scope :recommends, -> { where(origin: 'recommended') }
  scope :recents, -> { where(origin: 'recents') }
  scope :expiring, -> { where(origin: 'expiring') }
  
  def to_partial_path
    "projects/project"
  end

  #def display_image
  # end

  #def progress_bar
  # end 
end
