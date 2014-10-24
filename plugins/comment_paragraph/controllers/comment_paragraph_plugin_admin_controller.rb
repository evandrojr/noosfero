class CommentParagraphPluginAdminController < AdminController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
    @settings = Noosfero::Plugin::Settings.new(environment, CommentParagraphPlugin, params[:settings])
    @article_types = []
    available_article_types.each do |type|
      @article_types.push({
        :class_name => type.name,
        :short_description => type.short_description,
        :description => type.description
      })
    end

    if request.post?
      @settings.settings[:auto_marking_article_types].reject! { |type| type.blank? }
      @settings.save!
      redirect_to :controller => 'plugins', :action => 'index'
    end
  end

  protected

  def available_article_types
    articles = [TinyMceArticle, TextileArticle] + @plugins.dispatch(:content_types)
    articles
  end

end
