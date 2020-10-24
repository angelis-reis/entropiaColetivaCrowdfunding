# coding: utf-8
class ProjectsController < ApplicationController
  after_filter :verify_authorized, except: %i[index video video_embed embed embed_panel about_mobile]
  after_filter :redirect_user_back_after_login, only: %i[index show]
  before_action :authorize_and_build_resources, only: %i[edit show]

  has_scope :pg_search, :by_category_id, :near_of
  has_scope :recent, :expiring, :successful, :in_funding, :recommended, :not_expired, type: :boolean

  helper_method :project_comments_canonical_url, :resource, :collection

  respond_to :html
  respond_to :json, only: [:index, :show, :update]

  def index
    respond_to do |format|
      format.html do
        return render_index_for_xhr_request if request.xhr?
        projects_for_home
      end
      format.atom do
        return render layout: false, locals: {projects: projects}
      end
      format.rss { redirect_to projects_path(format: :atom), :status => :moved_permanently }
    end
  end

  def new
    @project = Project.new user: current_user
    authorize @project
    @project.rewards.build
  end

  def create
    @project = Project.new
    @project.attributes = permitted_params.merge(user: current_user, referral_link: referral_link)
    authorize @project
    if @project.save
      redirect_to edit_project_path(@project, anchor: 'home')
    else
      render :new
    end
  end

  def destroy
    authorize resource
    destroy!
  end

  def send_to_analysis
    authorize resource
    resource_action :send_to_analysis
  end

  def publish
    authorize resource
    resource_action :push_to_online
  end

  def update
    authorize resource

    #need to check this before setting new attributes
    should_validate = should_use_validate

    resource.attributes = permitted_params

    project = Project.includes(:contributions).find(params[:id])

    if (defined? params[:project][:uploaded_image])
      if params[:project][:uploaded_image].present?
        sended = false
        Dir.mkdir('public/uploads/project/uploaded_image/' << project.id.to_s) unless File.exists?('public/uploads/project/uploaded_image/' << project.id.to_s)
        path = File.join(Rails.root, "/public/uploads/project/uploaded_image/" + project.id.to_s, params[:project][:uploaded_image].original_filename)
        file_name = params[:project][:uploaded_image].original_filename
        File.open(path, "wb") do |f|
          f.write(params[:project][:uploaded_image].read)
        end
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/project/uploaded_image/" + project.id.to_s + '/project_thumb_' + file_name
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/project/uploaded_image/" + project.id.to_s + '/project_thumb_facebook_' + file_name
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/project/uploaded_image/" + project.id.to_s + '/project_thumb_large_' + file_name
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/project/uploaded_image/" + project.id.to_s + '/project_thumb_small_' + file_name
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/project/uploaded_image/" + project.id.to_s + '/project_thumb_facebook_' + file_name

        ActiveRecord::Base.connection.execute("UPDATE projects SET uploaded_image = '#{file_name}' WHERE id = '#{project.id}'")
      end
    end

    if (defined? params[:project][:goal])
      if params[:project][:goal].present?
        project.goal = params[:project][:goal]
      end
    end

    if (defined? params[:project][:online_days])
      if params[:project][:online_days].present?
        project.online_days = params[:project][:online_days]
      end
    end

    if (defined? params[:project][:video_embed_url])
      if params[:project][:video_embed_url].present?
        if (params[:project][:video_embed_url].include? "youtube") && (params[:project][:video_embed_url].include? "watch")
          code = params[:project][:video_embed_url].split("/watch?v=").last
          project.video_embed_url = "https://www.youtube.com/embed/"+code
        end
      end
    end

    if (defined? params[:project][:about_html])
      if params[:project][:about_html].present?
        project.about_html = params[:project][:about_html]
      end
    end

    if (defined? params[:project][:headline])
      if params[:project][:headline].present?
        project.headline = params[:project][:headline]
      end
    end

    unless permitted_params[:rewards_attributes].nil?
      permitted_params[:rewards_attributes].each_with_index do |item|
        reward = project.rewards.find(item[1]["id"]) unless item[1]["id"].nil?
        if reward.nil?
          project.rewards.create(item[1])
        else
          reward.update_attributes(item[1])
        end
      end
    end

    unless permitted_params[:user_attributes].nil?
      unless permitted_params[:user_attributes][:links_attributes].nil?
        permitted_params[:user_attributes][:links_attributes].each_with_index do |item|
          link = project.user.links.find(item[1]["id"]) unless item[1]["id"].nil?
          if item[1]["link"].strip.eql?("http://") || item[1]["link"].strip.eql?("https://")
            link.destroy
          else
            if link.nil?
              project.user.links.create(item[1])
            else
              link.update_attributes(item[1])
            end
          end
        end
      end
    end
    project.save

    user = User.find(project.user_id)
    if (defined? params[:project][:user_attributes][:name])
      user.name = params[:project][:user_attributes][:name]
    end

    if (defined? params[:project][:user_attributes][:email])
      user.email = params[:project][:user_attributes][:email]
    end

    if (defined? params[:project][:user_attributes][:about_html])
      user.about_html = params[:project][:user_attributes][:about_html]
    end

    if (defined? params[:project][:user_attributes][:facebook_link])
      user.facebook_link = params[:project][:user_attributes][:facebook_link]
    end

    if (defined? params[:project][:user_attributes][:twitter])
      user.twitter = params[:project][:user_attributes][:twitter]
    end

    if (defined? params[:project][:user_attributes][:uploaded_image])
      if params[:project][:user_attributes][:uploaded_image].present?
        sended = false
        Dir.mkdir('public/uploads/user/uploaded_image/' << user.id.to_s) unless File.exists?('public/uploads/user/uploaded_image/' << user.id.to_s)
        path = File.join(Rails.root, "/public/uploads/user/uploaded_image/" + user.id.to_s, params[:project][:user_attributes][:uploaded_image].original_filename)
        file_name = params[:project][:user_attributes][:uploaded_image].original_filename
        File.open(path, "wb") do |f|
          f.write(params[:project][:user_attributes][:uploaded_image].read)
        end
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/user/uploaded_image/" + user.id.to_s + '/thumb_avatar_' + file_name
        FileUtils.cp path, Rails.root.to_s + "/public/uploads/user/uploaded_image/" + user.id.to_s + '/thumb_facebook_' + file_name

        ActiveRecord::Base.connection.execute("UPDATE users SET uploaded_image = '#{file_name}' WHERE id = '#{user.id}'")
      end
    end

    user.save

    # if params[:project][:user_attributes][:links_attributes].present?
    #   # ActiveRecord::Base.connection.execute("DELETE FROM user_links WHERE user_id = '#{user.id}'")
    # end

    project_account = ProjectAccount.where(project_id: project.id).first
    if project_account == nil
      var_create = 1
      project_account = ProjectAccount.new
      project_account.project_id = project.id
    else
      var_create = 0
    end

    if (defined? params[:project][:account_attributes][:entity_type])
      if params[:project][:account_attributes][:entity_type].present?
        project_account.account_type = params[:project][:account_attributes][:entity_type]
      end
    end

    if (defined? params[:project][:account_attributes][:owner_name])
      if params[:project][:account_attributes][:owner_name].present?
        project_account.owner_name = params[:project][:account_attributes][:owner_name]
      end
    end

    if (defined? params[:project][:account_attributes][:email])
      if params[:project][:account_attributes][:email].present?
        project_account.email = params[:project][:account_attributes][:email]
      end
    end

    if (defined? params[:project][:account_attributes][:owner_document])
      if params[:project][:account_attributes][:owner_document].present?
        project_account.owner_document = params[:project][:account_attributes][:owner_document]
      end
    end

    if (defined? params[:project][:account_attributes][:bank_id])
      if params[:project][:account_attributes][:bank_id].present?
        project_account.bank_id = params[:project][:account_attributes][:bank_id]
      end
    end

    if (defined? params[:project][:account_attributes][:agency])
      if params[:project][:account_attributes][:agency].present?
        project_account.agency = params[:project][:account_attributes][:agency]
      end
    end

    if (defined? params[:project][:account_attributes][:agency_digit])
      project_account.agency_digit = params[:project][:account_attributes][:agency_digit]
    end

    if (defined? params[:project][:account_attributes][:account])
      if params[:project][:account_attributes][:account].present?
        project_account.account = params[:project][:account_attributes][:account]
      end
    end

    if (defined? params[:project][:account_attributes][:account_digit])
      if params[:project][:account_attributes][:account_digit].present?
        project_account.account_digit = params[:project][:account_attributes][:account_digit]
      end
    end

    if (defined? params[:project][:account_attributes][:address_street])
      if params[:project][:account_attributes][:address_street].present?
        project_account.address_street = params[:project][:account_attributes][:address_street]
      end
    end

    if (defined? params[:project][:account_attributes][:address_number])
      if params[:project][:account_attributes][:address_number].present?
        project_account.address_number = params[:project][:account_attributes][:address_number]
      end
    end

    if (defined? params[:project][:account_attributes][:address_complement])
      if params[:project][:account_attributes][:address_complement].present?
        project_account.address_complement = params[:project][:account_attributes][:address_complement]
      end
    end

    if (defined? params[:project][:account_attributes][:address_neighbourhood])
      if params[:project][:account_attributes][:address_neighbourhood].present?
        project_account.address_neighbourhood = params[:project][:account_attributes][:address_neighbourhood]
      end
    end

    if (defined? params[:project][:account_attributes][:address_city])
      if params[:project][:account_attributes][:address_city].present?
        project_account.address_city = params[:project][:account_attributes][:address_city]
      end
    end

    if (defined? params[:project][:account_attributes][:address_state])
      if params[:project][:account_attributes][:address_state].present?
        project_account.address_state = params[:project][:account_attributes][:address_state]
      end
    end

    if (defined? params[:project][:account_attributes][:address_zip_code])
      if params[:project][:account_attributes][:address_zip_code].present?
        project_account.address_zip_code = params[:project][:account_attributes][:address_zip_code]
      end
    end

    if (defined? params[:project][:account_attributes][:phone_number])
      if params[:project][:account_attributes][:phone_number].present?
        project_account.phone_number = params[:project][:account_attributes][:phone_number]
      end
    end
    if var_create == 1
      project_account.save
    else
      project_account.save
    end

    if (defined? params[:project][:posts_attributes])
      post = ProjectPost.new
      post.user_id = resource.user
      post.project_id = project.id
      if params[:project][:posts_attributes].present?
        post.title = params[:project][:posts_attributes]['0']['title']
      end
      if params[:project][:posts_attributes].present?
        post.comment_html = params[:project][:posts_attributes]['0']['comment_html']
        if post.save 
          project.payments.each do |p|
            # TODO fix sidekiq asyncs
            NewPostMailSenderWorker.new.perform(post, p.user.email, project)
          end
        end
      end
    end

    if params[:anchor]
      redirect_to edit_project_path(@project, anchor: params[:anchor])
    else
      redirect_to edit_project_path(@project, anchor: 'home')
    end
  end

  def show
    fb_admins_add(resource.user.facebook_id) if resource.user.facebook_id
  end

  def video
    project = Project.new(video_url: params[:url])
    render json: project.video.to_json
  rescue VideoInfo::UrlError
    render json: nil
  end

  def embed
    resource
    render partial: 'card', layout: 'embed', locals: {embed_link: true}
  end

  def embed_panel
    resource
    render partial: 'project_embed'
  end

  def about_mobile
    resource
  end

  protected
  def authorize_and_build_resources
    authorize resource
    build_dependencies
  end

  def build_dependencies
    @posts_count = resource.posts.count(:all)
    @user = resource.user
    @user.links.build
    @post =  (params[:project_post_id].present? ? resource.posts.where(id: params[:project_post_id]).first : resource.posts.build)
    @rewards = @project.rewards.rank(:row_order)
    @rewards = @project.rewards.build unless @rewards.present?
    # @budget = resource.budgets.build

    resource.build_account unless resource.account
  end

  def resource_action action_name
    if resource.send(action_name)
      if referral_link.present?
        resource.update_attribute :referral_link, referral_link
      end

      flash[:notice] = t("projects.#{action_name.to_s}")
      redirect_to edit_project_path(@project, anchor: 'home')
    else
      flash.now[:notice] = t("projects.#{action_name.to_s}_error")
      build_dependencies
      render :edit
    end
  end

  def render_index_for_xhr_request
    render partial: 'projects/card',
      collection: projects,
      layout: false,
      locals: {ref: "explore", wrapper_class: 'w-col w-col-4 u-marginbottom-20'}
  end

  def projects
    page = params[:page] || 1
    @projects ||= apply_scopes(Project.visible.order_status).
      most_recent_first.
      includes(:project_total, :user, :category).
      page(page).per(18)
  end

  def projects_for_home
    # @recommends = ProjectsForHome.recommends.includes(:project_total, :user)
    @recommends = apply_scopes(Project.visible.order_status).recommended.most_recent_first.limit(6).includes(:project_total, :user, :category)
    @projects_near = Project.with_state('online').near_of(current_user.address_state).order("random()").limit(3).includes(:project_total, :user) if current_user
    @expiring = ProjectsForHome.expiring.includes(:project_total, :user)
    @recent   = ProjectsForHome.recents.includes(:project_total, :user)
  end

  def should_use_validate
    resource.valid?
  end

  def permitted_params
    params.require(:project).permit(policy(resource).permitted_attributes)
  end

  def resource
    @project ||= (params[:permalink].present? ? Project.by_permalink(params[:permalink]).first! : Project.find(params[:id]))
  end

  def project_comments_canonical_url
    url = project_by_slug_url(resource.permalink, protocol: 'http', subdomain: 'www').split('/')
    url.delete_at(3) #remove language from url
    url.join('/')
  end
end
