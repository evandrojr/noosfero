class CommunityHubPluginPublicController < PublicController

	append_view_path File.join(File.dirname(__FILE__) + '/../../views')

	layout false


	def newer_comments
		latest_post = params[:latest_post]
    hub = params[:hub]
		posts = Comment.find(:all,
                         :order => "id desc", 
                        :conditions => ["id > ?", latest_post])

		if !posts.empty?
			oldest_post = posts.last.id
			latest_post = posts.first.id
		else
			oldest_post = 0
			latest_post = 0
		end

    #raise hub.inspect

		render :partial => "post", 
					 :collection => posts, 
					 :locals => {
					 		:latest_post => latest_post, 
					 		:oldest_post => oldest_post,
              :hub => hub
					 }
	end


  def newer_articles
    latest_post = params[:latest_post]
    hub = params[:hub]
    posts = Article.find(:all,
                         :order => "id desc", 
                         :conditions => ["id > :id and type = :type and parent_id = :hub", {
                            :id => latest_post, 
                            :type => 'TinyMceArticle', 
                            :hub => hub
                          }])

    if !posts.empty?
      oldest_post = posts.last.id
      latest_post = posts.first.id
    else
      oldest_post = 0
      latest_post = 0
    end

    render :partial => "post", 
           :collection => posts,
           :locals => {
              :latest_post => latest_post, 
              :oldest_post => oldest_post,
              :hub => hub
           }
  end


	def more_comments
		@posts = Comment.find(:all)
		render :partial => "post", :collection => @posts
	end



  def settings
  	settings_section = params[:id]
  	render :partial => "settings/twitter", :layout => true
  end


  def set_hub_view
		hub = Article.find(params[:hub])
		hub_owner = hub.profile
  	role = params[:role]
  	render :partial => "post_form", :locals => {:hub => hub, :profile => user, :user_role => role}
  end


  def check_user_level
  	if false
  		render :text => {'level' => 0}.to_json, :content_type => 'application/json'
  	else
  		render :text => {'level' => 1}.to_json, :content_type => 'application/json'
  	end
  end


  def remove_live_post

  	begin
  		post = Comment.find(params[:id])
  	rescue
  		post = nil
  	end

    if post && post.destroy
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end  	

  end


	def promote_live_post

		post_id = params[:id]
		user_id = params[:user].to_i

		hub = Article.find(params[:hub])

		hub.promoted_users += [user_id] unless hub.promoted_users.include?(user_id)

    if hub && hub.save
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
	end


	def pin_live_post

  	begin
  		post = Comment.find(params[:id])
  	rescue
  		post = nil
  	end

		hub = Article.find(params[:hub])

  	hub.pinned_posts += [post.id] unless hub.pinned_posts.include?(post.id)

    if hub && hub.save
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
	end


	#
	# to implement..........
	#
	def like_live_post
    if false
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
	end


	#
	# to implement..........
	#
	def dislike_live_post
    if false
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
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