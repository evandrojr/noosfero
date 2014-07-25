class CommentParagraphPluginPublicController < PublicController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def comment_paragraph
    @comment = Comment.find(params[:id])
    render :json => { :paragraph_id => comment.paragraph_id }
  end

end
