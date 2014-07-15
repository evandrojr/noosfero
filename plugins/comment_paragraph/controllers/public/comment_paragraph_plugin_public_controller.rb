class CommentParagraphPluginPublicController < PublicController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def comment_paragraph
    render :json => { :paragraph_id => Comment.find(params[:id]).paragraph_id }
  end

end
