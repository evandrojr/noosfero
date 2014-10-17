require 'noosfero/translatable_content'
require 'application_helper'
require 'net/http'

class Video < Article

  settings_items :video_url,    :type => :string, :default => 'http://'
  settings_items :video_width,  :type => :integer, :default => 499
  settings_items :video_height, :type => :integer, :default => 353
  #youtube, vimeo, file
  settings_items :video_provider,    :type => :string
  settings_items :video_format,      :type => :string
  settings_items :video_id,          :type => :string
  settings_items :video_thumbnail_url,    :type => :string, :default => '/plugins/video/images/video_generic_thumbnail.jpg'
  settings_items :video_thumbnail_width,  :type=> :integer
  settings_items :video_thumbnail_height, :type=> :integer
  settings_items :video_duration, :type=> :integer, :default => 0

  attr_accessible :video_url

  before_save :detect_video

  def self.type_name
    _('Video')
  end

  def can_display_versions?
    true
  end

  def self.short_description
    _('Embedded Video')
  end

  def self.description
    _('Display embedded videos.')
  end

  include ActionView::Helpers::TagHelper
  def to_html(options={})
    article = self
    proc do
      render :partial => 'content_viewer/video', :locals => {:article => article}
    end
  end

  def fitted_width
    499
  end
  
  def fitted_height
    ((fitted_width * self.video_height) / self.video_width).to_i
  end
  
  def thumbnail_fitted_width
    80
  end

  def thumbnail_fitted_height
    ((thumbnail_fitted_width * self.video_thumbnail_height) / self.video_thumbnail_width).to_i
  end
  
  def no_browser_support_message
    '<p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p>'    
  end
  
  private
  
  YOUTUBE_ID_FORMAT = '\w-'
  
  def detect_video
    if is_youtube? 
      self.video_provider = 'youtube'
      self.video_id = extract_youtube_id
      url = "http://www.youtube.com/oembed?url=http%3A//www.youtube.com/watch?v%3D#{self.video_id}&format=json"
      resp = Net::HTTP.get_response(URI.parse(url))
      buffer = resp.body
      vid = JSON.parse(buffer)
      self.video_thumbnail_url = vid['thumbnail_url']
      self.video_width = vid['width']
      self.video_height = vid['height'] 
      self.video_thumbnail_width = vid['thumbnail_width']
      self.video_thumbnail_height = vid['thumbnail_height']
      url = "http://gdata.youtube.com/feeds/api/videos/#{self.video_id}?alt=json";
      resp = Net::HTTP.get_response(URI.parse(url))
      buffer = resp.body
      vid = JSON.parse(buffer)
      self.video_duration = vid['entry']['media$group']['media$content'][0]['duration']
    elsif is_vimeo? 
      self.video_provider = 'vimeo'
      self.video_id = extract_vimeo_id
      url = "http://vimeo.com/api/v2/video/#{self.video_id}.json"
      resp = Net::HTTP.get_response(URI.parse(url))
      buffer = resp.body
      vid = JSON.parse(buffer)
      vid = vid[0]
      #raise vid.to_yaml
      self.video_thumbnail_url = vid['thumbnail_large']
      self.video_width = vid['width']
      self.video_height = vid['height'] 
      self.video_thumbnail_width = 640
      self.video_thumbnail_height = 360
    elsif true
      self.video_format = detect_format
      self.video_provider = 'file'
    end
  end
  
  def detect_format
   video_type = 'video/unknown'
   if /.mp4/i =~ self.video_url or /.mov/i =~ self.video_url 
    video_type='video/mp4'
   elsif /.webm/i =~ self.video_url
    video_type='video/webm'
   elsif /.og[vg]/i =~ self.video_url  
    video_type='video/ogg'
   end
   video_type
  end
  
  def is_youtube?
    video_url.match(/.*(youtube.com.*v=[#{YOUTUBE_ID_FORMAT}]+|youtu.be\/[#{YOUTUBE_ID_FORMAT}]+).*/) ? true : false
  end

  def is_vimeo?
    video_url.match(/^(http[s]?:\/\/)?(www.)?(vimeo.com|player.vimeo.com\/video)\/([A-z]|\/)*[[:digit:]]+/) ? true : false
  end

  def is_video_file?
    video_url.match(/\.(mp4|ogg|ogv|webm)/) ? true : false
  end
  
  def extract_youtube_id
    return nil unless is_youtube?
    youtube_match = video_url.match("v=([#{YOUTUBE_ID_FORMAT}]*)")
    youtube_match ||= video_url.match("youtu.be\/([#{YOUTUBE_ID_FORMAT}]*)")
    youtube_match[1] unless youtube_match.nil?
  end

  def extract_vimeo_id
    return nil unless is_vimeo?
    vimeo_match = video_url.match('([[:digit:]]*)$')
    vimeo_match[1] unless vimeo_match.nil?
  end
end

#To be used for the duration
#function formatSecondsAsTime(secs) {
#    var hr = Math.floor(secs / 3600);
#    var min = Math.floor((secs - (hr * 3600)) / 60);
#    var sec = Math.floor(secs - (hr * 3600) - (min * 60));
#
#    if (hr < 10) {
#        hr = "0" + hr;
#    }
#    if (min < 10) {
#        min = "0" + min;
#    }
#    if (sec < 10) {
#        sec = "0" + sec;
#    }
#    if (hr) {
#        hr = "00";
#    }
#
#    return hr + ':' + min + ':' + sec;
#}
