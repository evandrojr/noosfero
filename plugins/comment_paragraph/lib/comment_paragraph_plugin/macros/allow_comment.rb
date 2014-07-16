#FIXME See a better way to generalize this parameter.
ActionView::Base.sanitized_allowed_attributes += ['data-macro', 'data-macro-paragraph_id']

class CommentParagraphPlugin::AllowComment < Noosfero::Plugin::Macro
  def self.configuration
    { :params => [],
      :skip_dialog => true,
      :generator => 'makeCommentable();',
      :js_files => 'comment_paragraph.js',
      :icon_path => '/plugins/comment_paragraph/images/balloons-comment.png',
      :css_files => 'comment_paragraph.css' }
  end

  def parse(params, inner_html, source)
    paragraph_id = params[:paragraph_id].to_i
    article = source
    count = article.paragraph_comments.without_spam.in_paragraph(paragraph_id).count

    proc {
      render :partial => 'comment_paragraph_plugin_profile/comment_paragraph',
             :locals => {:paragraph_id => paragraph_id, :article_id => article.id, :inner_html => inner_html, :count => count, :profile_identifier => article.profile.identifier }
    }
  end
end
