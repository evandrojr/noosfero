class CommentParagraphPlugin < Noosfero::Plugin

  def self.plugin_name
    "Comment Paragraph"
  end

  def self.plugin_description
    _("A plugin that display comments divided by paragraphs.")
  end

  def unavailable_comments(scope)
    scope.without_paragraph
  end

  def comment_form_extra_contents(args)
    comment = args[:comment]
    paragraph_id = comment.paragraph_id || args[:paragraph_id]
    proc {
      hidden_field_tag('comment[paragraph_id]', paragraph_id) if paragraph_id
    }
  end

  def js_files
    'comment_paragraph_macro.js'
  end

  def stylesheet?
    true
  end


end

require_dependency 'comment_paragraph_plugin/macros/allow_comment'
