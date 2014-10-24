class CommentParagraphPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def view_comments
    @article_id = params[:article_id]
    @paragraph_id = params[:paragraph_id]
    article = profile.articles.find(@article_id)
    @comments = article.comments.without_spam.in_paragraph(@paragraph_id)
    @comments_count = @comments.count
    @comments = @comments.without_reply
  end

end
