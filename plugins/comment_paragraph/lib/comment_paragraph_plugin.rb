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
      arr = []
      arr << hidden_field_tag('comment[id]', comment.id)
      arr << hidden_field_tag('comment[paragraph_id]', paragraph_id) if paragraph_id
      arr << hidden_field_tag('comment[comment_paragraph_selected_area]', comment.comment_paragraph_selected_area) if comment.comment_paragraph_selected_area
      arr
    }
  end

  def comment_extra_contents(args)
    comment = args[:comment]
    proc {
      render :file => 'comment/comment_extra', :locals => {:comment => comment}
    }
  end

  def js_files
    ['comment_paragraph_macro', 'rangy-core', 'rangy-cssclassapplier', 'rangy-serializer']
  end

  def stylesheet?
    true
  end

  def cms_controller_filters
    block = proc do
      if params['commit'] == 'Save'

        settings = Noosfero::Plugin::Settings.new(environment, CommentParagraphPlugin, params[:settings])

        extend CommentParagraphPlugin::CommentParagraphHelper
        if !@article.id.blank? && self.auto_marking_enabled?(settings, @article.class.name)

          parsed_paragraphs = []
          paragraph_id = 0

          doc = Hpricot(@article.body)
          paragraphs = doc.search("/*").each do |paragraph|
            parsed_paragraphs << (paragraph.to_html =~ /^\n|\r\n|<p>\W<\/p>$|(.*)paragraph_comment_spacer(.*)|<div(.*)paragraph_comment(.*)$/ ? paragraph.to_html : CommentParagraphPlugin.parse_paragraph(paragraph.to_html, paragraph_id))
            paragraph_id += 1
          end

          @article.body = parsed_paragraphs.join()
          @article.save

        end
      end
    end

    { :type => 'after_filter',
      :method_name => 'new',
      :block => block }
  end

  private

  def self.parse_paragraph( paragraph_content, paragraph_id )
      "<div class='macro article_comments paragraph_comment' " +
           "data-macro='comment_paragraph_plugin/allow_comment' " +
           "data-macro-paragraph_id='#{paragraph_id}'>#{paragraph_content}</div>\r\n" +
      "<p class='paragraph_comment_spacer'>&nbsp;</p>\r\n"
  end

end

require_dependency 'comment_paragraph_plugin/macros/allow_comment'
