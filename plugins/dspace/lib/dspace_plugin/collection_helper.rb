module DspacePlugin::CollectionHelper

  include ArticleHelper

  def custom_options_for_article(article,tokenized_children)
    @article = article

    visibility_options(article,tokenized_children) +
    content_tag('div',
      hidden_field_tag('article[accept_comments]', 0)
    )
  end

end
