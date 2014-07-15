class CommentParagraphPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def view_comments
    @article_id = params[:article_id]
    @paragraph_id = params[:paragraph_id]

    article = profile.articles.find(@article_id)
    @paragraph_comment_page = (params[:paragraph_comment_page] || 1).to_i

    @comments = article.comments.without_spam.in_paragraph(@paragraph_id)
    @comments_count = @comments.count
    @comments = @comments.without_reply.paginate(:per_page => per_page, :page => @paragraph_comment_page )

    @no_more_pages = @comments_count <= @paragraph_comment_page * per_page
  end

  def per_page
    3
  end

end
