class CommunityHubPluginPublicController < PublicController

	append_view_path File.join(File.dirname(__FILE__) + '/../../views')

	#layout false

	def newer_comments
		posts = Comment.find(:all)
		#render :text => posts_to_json(posts), :content_type => 'text/plain'
		render :partial => "post", :collection => posts
	end

	def more_comments
		@posts = Comment.find(:all)
		render :partial => "post", :collection => @posts
	end

	def newer_articles
		posts = Article.find(:all, :conditions => {:type => 'TinyMceArticle'}, :limit => 3)
		render :partial => "post", :collection => posts
	end

  def settings
  	settings_section = params[:id]
  	#raise settings_section.inspect
  	render :partial => "settings/twitter", :layout => true
  end

	protected

  def posts_to_json(list)
    list.map do |item| {
    	'id' => item.id,
			'created_at' => item.created_at,
			'body' => item.body,
			'profile' => item.author
    }
    end.to_json
  end



end