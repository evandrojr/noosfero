require File.dirname(__FILE__) + '/../test_helper'
class VideoTest < ActiveSupport::TestCase

  include AuthenticatedTestHelper
  fixtures :users, :environments

  def setup
    @video = VideoPlugin::Video.new
  end
  
  should "define its type_name as video" do
    assert_equal VideoPlugin::Video.type_name, _('Video') 
  end
 
  should "display version" do
    assert @video.can_display_versions?
  end
  
  should "define its short_description" do
    assert_equal VideoPlugin::Video.short_description, _('Embedded Video')
  end

  should "define its description" do
    assert_equal VideoPlugin::Video.description, _('Display embedded videos.')
  end
  
  should "define a fitted_width" do
    assert_equal @video.fitted_width, 499
  end

  should "eval a fitted_height" do
    @video.video_height = 1000 
    @video.video_width =  2000 
    fitted_height = ((@video.fitted_width * @video.video_height) / @video.video_width).to_i
    assert_equal fitted_height, @video.fitted_height
  end  
  
  should "define a thumbnail_fitted_width" do
    assert_equal @video.thumbnail_fitted_width, 80
  end

  should "eval a thumbnail_fitted_height" do
    @video.video_thumbnail_height = 60 
    @video.video_thumbnail_width =  30 
    thumbnail_fitted_height = ((@video.thumbnail_fitted_width * @video.video_thumbnail_height) / @video.video_thumbnail_width).to_i
    assert_equal thumbnail_fitted_height, @video.thumbnail_fitted_height
  end    
  
  should "show a no_browser_support_message" do
    assert_equal @video.no_browser_support_message, '<p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p>'
  end
  
  
  ### Tests for YouTube

  should "is_youtube return true when the url contains http://youtube.com" do
    @video.url = "http://youtube.com/?v=XXXXX"
    assert @video.is_youtube?
  end

  
end
