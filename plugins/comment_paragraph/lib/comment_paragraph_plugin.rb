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
    paragraph_uuid = comment.paragraph_uuid || args[:paragraph_uuid]
    proc {
      arr = []
      arr << hidden_field_tag('comment[id]', comment.id)
      arr << hidden_field_tag('comment[paragraph_uuid]', paragraph_uuid) if paragraph_uuid
      arr << hidden_field_tag('comment[comment_paragraph_selected_area]', comment.comment_paragraph_selected_area) unless comment.comment_paragraph_selected_area.blank?
      arr << hidden_field_tag('comment[comment_paragraph_selected_content]', comment.comment_paragraph_selected_content) unless comment.comment_paragraph_selected_content.blank?
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

#  def cms_controller_filters
#    block = proc do
#      if params['commit'] == 'Save'
#
#        settings = Noosfero::Plugin::Settings.new(environment, CommentParagraphPlugin, params[:settings])
#
#        extend CommentParagraphPlugin::CommentParagraphHelper
#        if !@article.id.blank? && self.auto_marking_enabled?(settings, @article.class.name)
#
#          parsed_paragraphs = []
#          paragraph_uuid = 0
#
#          doc = Hpricot(@article.body)
#          paragraphs = doc.search("/*").each do |paragraph|
#
#            if paragraph.to_html =~ /^<div(.*)paragraph_comment(.*)$/ || paragraph.t o_html =~ /^<p>\W<\/p>$/
#              parsed_paragraphs << paragraph.to_html
#            else
#              if paragraph.to_html =~ /^(<div|<table|<p|<ul).*/
#                parsed_paragraphs << CommentParagraphPlugin.parse_paragraph(paragraph.to_html, paragraph_uuid)
#              else
#                parsed_paragraphs << paragraph.to_html
#              end
#            end
#
#            paragraph_uuid += 1
#
#          end
#
#          @article.body = parsed_paragraphs.join()
#          @article.save
#
#        end
#      end
#    end
#
#    { :type => 'after_filter',
#      :method_name => 'new',
#      :block => block }
#  end


  def self.parse_paragraph( paragraph_content, paragraph_uuid )
      "<div class='macro article_comments paragraph_comment' " +
           "data-macro='comment_paragraph_plugin/allow_comment' " +
           "data-macro-paragraph_uuid='#{paragraph_uuid}'>#{paragraph_content}</div>\r\n" +
      "<p>&nbsp;</p>"
  end

end

require_dependency 'comment_paragraph_plugin/macros/allow_comment'
