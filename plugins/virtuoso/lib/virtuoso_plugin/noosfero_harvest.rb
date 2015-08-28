class VirtuosoPlugin::NoosferoHarvest

  COMMON_MAPPING = {
    :type => {:predicate => ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "http://purl.org/dc/terms/type"], :value => lambda {|s, t| t.class.name}},
    :created_at => {:predicate => "http://purl.org/dc/terms/created"},
    :updated_at => {:predicate => "http://purl.org/dc/terms/modified"},
  }

  ARTICLE_MAPPING = {
    :title => {:predicate => "http://purl.org/dc/terms/title"},
    :abstract => {:predicate => "http://purl.org/dc/terms/abstract"},
    :body => {:predicate => "http://purl.org/dc/terms/description"},
    :participation => {:predicate => "http://purl.org/socialparticipation/ops#performsParticipation", :value => lambda {|s,t| url_for(t.url)}, :subject => lambda {|s,t| url_for(s.url)} },
    :part_of => {:predicate => "http://purl.org/dc/terms/isPartOf", :value => lambda {|s, t| url_for(s.url)} },
    :published_at => {:predicate => "http://purl.org/dc/terms/issued"},
    :author => {:predicate => "http://purl.org/dc/terms/creator", :value => lambda {|s, t| url_for(t.author_url) if t.author_url} },
  }
  PROFILE_MAPPING = {
    :name => {:predicate => "http://xmlns.com/foaf/0.1/name"},
    :contributor => {:predicate => "http://purl.org/dc/terms/contributor", :value => lambda {|s, t| url_for(s.top_url)} },
    :public? => {:predicate => "http://purl.org/socialparticipation/opa#publicProfile"},
    :visible => {:predicate => "http://purl.org/socialparticipation/opa#visibleProfile"},
    :lat => {:predicate => "http://www.w3.org/2003/01/geo/wgs84_pos#lat"},
    :lng => {:predicate => "http://www.w3.org/2003/01/geo/wgs84_pos#lng"},
    :type_community => {:predicate => "http://xmlns.com/foaf/0.1/Group", :condition => lambda {|s,t| t.community?} },
    :type_organization => {:predicate => "http://xmlns.com/foaf/0.1/Organization", :condition => lambda {|s,t| !t.person? && !t.community?} },
  }
  PERSON_MAPPING = {
    :type_participant => {:predicate => "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", :value => "http://purl.org/socialparticipation/ops#Participant"},
    :type_person => {:predicate => "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", :value => "http://xmlns.com/foaf/0.1/Person"},
    :email => {:predicate => "http://xmlns.com/foaf/0.1/mbox", :condition => lambda {|s,t| t.public? } }
  }
  COMMENT_MAPPING = {
    :title => {:predicate => "http://purl.org/dc/terms/title"},
    :body => {:predicate => "http://schema.org/text"},
    :part_of => {:predicate => "http://purl.org/dc/terms/isPartOf", :value => lambda {|s, t| url_for(s.url)} },
    :author => {:predicate => "http://purl.org/dc/terms/creator", :value => lambda {|s, t| url_for(t.author_url) if t.author_url} },
    :participation => {:predicate => "http://purl.org/socialparticipation/ops#performsParticipation", :value => lambda {|s,t| url_for(t.url)}, :subject => lambda {|s,t| url_for(s.profile.url)} },
  }
  FRIENDSHIP_MAPPING = {
    :knows => {:predicate => "http://xmlns.com/foaf/0.1/knows", :value => lambda {|s, t| url_for(t.url)} },
    :type => nil, :created_at => nil, :updated_at => nil,
  }

  def initialize(environment)
    @environment = environment
    @graph = environment.top_url
  end

  attr_reader :environment

  def plugin
    @plugin ||= VirtuosoPlugin.new(self)
  end

  delegate :settings, :to => :plugin

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::SanitizeHelper

  def triplify_comments(article)
    total = article.comments.count
    count = 0
    article.comments.find_each do |comment|
      begin
        subject_identifier = url_for(comment.url)
        puts "triplify #{subject_identifier} comment (#{count+=1}/#{total})"
        triplify_mappings(COMMENT_MAPPING, subject_identifier, article, comment)
      rescue => ex
        puts "FAILED: #{ex}"
      end
    end
  end

  def triplify_articles(profile)
    total = profile.articles.count
    count = 0
    profile.articles.public.each do |article|
      begin
        subject_identifier = url_for(article.url)
        puts "triplify #{subject_identifier} article (#{count+=1}/#{total})"
        triplify_mappings(ARTICLE_MAPPING, subject_identifier, profile, article)
        triplify_comments(article)
      rescue => ex
        puts "FAILED: #{ex}"
      end
    end
  end

  def triplify_friendship(person)
    total = person.friends.count
    count = 0
    person.friends.each do |friend|
      begin
        subject_identifier = url_for(person.url)
        puts "triplify #{subject_identifier} friendship (#{count+=1}/#{total})"
        triplify_mappings(FRIENDSHIP_MAPPING, subject_identifier, person, friend)
      rescue => ex
        puts "FAILED: #{ex}"
      end
    end
  end

  def triplify_profiles
    total = environment.profiles.count
    count = 0
    environment.profiles.find_each do |profile|
      begin
        subject_identifier = url_for(profile.url)
        puts "triplify #{subject_identifier} profile (#{count+=1}/#{total})"
        triplify_mappings(PROFILE_MAPPING, subject_identifier, environment, profile)
        triplify_articles(profile) if profile.public?
        if profile.person?
          triplify_friendship(profile)
          triplify_mappings(PERSON_MAPPING, subject_identifier, environment, profile, false)
        end
      rescue => ex
        puts "FAILED: #{ex}"
      end
    end
  end

  def run
    triplify_profiles
  end

  protected

  def triplify_mappings(mapping, subject_identifier, source, target, include_common = true)
    target_mapping = include_common ? COMMON_MAPPING.merge(mapping) : mapping
    target_mapping.each do |k, v|
      next unless v
      next if v[:condition] && v[:condition].call(source, target)

      subject_identifier = v[:subject].call(source, target) if v[:subject]

      value = nil
      if v[:value]
        value = v[:value].kind_of?(Proc) ? v[:value].call(source, target) : v[:value]
      elsif target.respond_to?(k)
        value = target.send(k)
      end
      [v[:predicate]].flatten.compact.each do |predicate|
        insert_triple(RDF::URI.new(subject_identifier), RDF::URI.new(predicate), value) if value.present?
      end
    end
  end

  def process_value(value)
    if value.kind_of?(String)
      value = /^https?:\/\//.match(value) ? RDF::URI.new(value) : RDF::Literal.new(strip_tags(value).delete("\n|\r"))
    else
      value = RDF::Literal.new(value)
    end
  end

  def insert_triple(subject, predicate, value)
    query = RDF::Virtuoso::Query.insert_data([RDF::URI.new(subject),
                                              RDF::URI.new(predicate),
                                              process_value(value)]).graph(RDF::URI.new(@graph))
    plugin.virtuoso_client.insert(query)
  end

end
