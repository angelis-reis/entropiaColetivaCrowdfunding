class PostsForHome < Post
  self.table_name = 'posts_for_home'
  has_one :post, class_name: "ProjectPost", inverse_of: :project

  scope :recent, -> { where(online_date: 10.days.ago.. Time.current) }
  

  def to_partial_path
    "projects/project_posts"
  end
end
