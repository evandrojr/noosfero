require File.dirname(__FILE__) + '/../test_helper'

class ContentViewerController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')
  def rescue_action(e)
    raise e
  end
end

class ContentViewerControllerTest < ActionController::TestCase

  def setup
    @profile = fast_create(Community)
    @page = fast_create(Article, :profile_id => @profile.id, :body => "<div class=\"macro\" data-macro-paragraph_id=\"0\" data-macro='comment_paragraph_plugin/allow_comment' ></div>")
    @environment = Environment.default
    @environment.enable_plugin(CommentParagraphPlugin)
  end

  attr_reader :page

  should 'parse article body and render comment paragraph view' do
    comment1 = fast_create(Comment, :paragraph_id => 0, :source_id => page.id)
    get :view_page, @page.url
    assert_tag 'div', :attributes => {:class => 'comment_paragraph'}
  end

end
