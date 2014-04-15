class CommunityHubPluginPublicController < PublicController

	append_view_path File.join(File.dirname(__FILE__) + '/../../views')

	layout false


  def new_message
    article = Article.find(params[:article_id])

    message_data = {}
    message_data.merge!(params[:message]) if params[:message]

    @message = Comment.new(message_data)
    @message.author = user if logged_in?
    @message.title = message_timestamp
    @message.article = article
    @message.ip_address = request.remote_ip
    @message.user_agent = request.user_agent
    @message.referrer = request.referrer    

    if @message && @message.save
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
  end


  def new_mediation
    profile = Profile.find(params[:profile_id])

    mediation_data = {}
    mediation_data.merge!(params[:article]) if params[:article]

    @mediation = TinyMceArticle.new(mediation_data)
    @mediation.profile = profile
    @mediation.last_changed_by = user
    @mediation.name = mediation_timestamp
    @mediation.notify_comments = false
    @mediation.type = 'TinyMceArticle'
    @mediation.advertise = false
    @mediation.save

    if @mediation && @mediation.save
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
  end


  def newer_mediation_comment
    latest_id = params[:latest_post]
    mediation = params[:mediation]
    comments = Comment.find(:all, 
                            :limit => 100,
                            :conditions => ["id > :id and source_id = :mediation", {
                              :id => latest_id, 
                              :mediation => mediation
                            }])

    render :partial => "mediation_comment", 
           :collection => comments
  end


	def newer_comments
		latest_post = params[:latest_post]
    hub = Article.find(params[:hub])
		posts = Comment.find(:all,
                         :order => "id desc",
                         :limit => 100,
                         :conditions => ["id > :id and source_id = :hub", {
                           :id => latest_post,
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


  def newer_articles
    latest_post = params[:latest_post]
    hub = Article.find(params[:hub])
    posts = Article.find(:all,
                         :order => "id desc", 
                         :limit => 100,
                         :conditions => ["id > :id and type = :type and parent_id = :hub", {
                            :id => latest_post, 
                            :type => 'TinyMceArticle', 
                            :hub => hub.id
                          }])

    if !posts.empty?
      oldest_post = posts.last.id
      latest_post = posts.first.id
    else
      oldest_post = 0
      latest_post = 0
    end

    render :partial => "mediation", 
           :collection => posts,
           :locals => {
              :latest_post => latest_post, 
              :oldest_post => oldest_post,
              :hub => hub
           }
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


	def promote_user
    hub = Article.find(params[:hub])

		user_id = params[:user].to_i

		hub.mediators += [user_id] unless hub.mediators.include?(user_id)

    if hub && hub.save
      render :text => {'ok' => true}.to_json, :content_type => 'application/json'
    else
      render :text => {'ok' => false}.to_json, :content_type => 'application/json'
    end
	end


	def pin_message
    message = Comment.find(params[:message])
    hub = Article.find(params[:hub])
    community = Profile.find(params[:community])

    mediation = make_mediation_from_message(community, hub, message)
    mediation.save

    if mediation && mediation.save 
      hub.pinned_messages += [message.id] unless hub.pinned_messages.include?(message.id)
      hub.pinned_mediations += [mediation.id] unless hub.pinned_mediations.include?(mediation.id)
      hub.save
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


  def make_mediation_from_message(community, hub, message)
    begin
      mediation = Article.new

      mediation.profile = community
      mediation.parent = hub
      mediation.name = mediation_timestamp
      mediation.body = message.body
      mediation.abstract = ""
      mediation.last_changed_by = message.author
      mediation.type = 'TinyMceArticle'
      mediation.display_versions = false
      mediation.moderate_comments = false
      mediation.translation_of_id = ""
      mediation.notify_comments = false
      mediation.accept_comments = true
      mediation.tag_list = ""
      mediation.allow_members_to_edit = false
      mediation.display_hits = false
      mediation.published = true
      mediation.license_id = ""
      mediation.category_ids = []
      #mediation.save
    rescue
      mediation = nil
    end

    mediation
  end


  def mediation_timestamp
    "hub-mediation-#{(Time.now.to_f * 1000).to_i}"
  end
  
  def message_timestamp
    "hub-message-#{(Time.now.to_f * 1000).to_i}"
  end

end