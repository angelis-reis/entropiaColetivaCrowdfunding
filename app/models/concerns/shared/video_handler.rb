module Shared::VideoHandler
  extend ActiveSupport::Concern

  included do
    validates_format_of :video_url, with: /(https?\:\/\/|)(youtu(\.be|be\.com)|vimeo).*+/, message: I18n.t('project.video_regex_validation'), allow_blank: true

    def video
      @video ||= VideoInfo.get(self.video_url) if self.video_url.present?
    end

    def video_valid?
      self.video_url.present? && self.video
    end

    def display_video_embed_url
      if self.video_embed_url
        "#{self.video_embed_url}?title=0&byline=0&portrait=0&autoplay=0"
      end
    end

    def update_video_embed_url
      self.video_embed_url = self.video.embed_url if self.video_valid?
      # if self.video_embed_url
        if (self.video_embed_url.include? "youtube") && (self.video_embed_url.include? "watch")
          convert_you_tube_video
        end
      # end
      self.save(validate: false)
    end

    #convert you tube video to embed video
    def convert_you_tube_video
      code = self.video_embed_url.split("/watch?v=").last
      self.video_embed_url = "https://www.youtube.com/embed/"+code
      self.save
    end
  end

end
