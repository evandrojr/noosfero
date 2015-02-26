require 'nokogiri'
require 'open-uri'

class EmailArticlePluginMyprofileController < MyProfileController

  needs_profile
  
  class Webpage < Nokogiri::HTML::Document
    attr_accessor :url

    class << self

      def new(url)
        html = open(url)
        self.parse(html).tap do |d|
          d.url = url
        end
      end
    end
  end  

  def send_email
    if user.is_admin?(profile)
      article = profile.articles.find(params[:id])
#      article = Article.find(params[:id])
      EmailArticlePluginMyprofileController::Sender.content(article).deliver
      render :text => "Email sent to queue"
    else
      render :status => :forbidden, :text => "Forbidden user"
    end
  end

  class Sender < ActionMailer::Base
    def content(article)
      doc = Nokogiri::HTML(article.body)
      doc.css("a").each do |link|
        unless link.attribute("href").nil? 
          relative_path = link.attribute("href").value 
          link.attribute("href").value = "http://#{article.environment.default_hostname}/#{relative_path}"        
        end
      end
      
      doc.css("img").each do |link|
        unless link.attribute("src").nil? 
          relative_path = link.attribute("src").value 
          link.attribute("src").value = "http://#{article.environment.default_hostname}/#{relative_path}"        
        end
      end
      

#        link.attributes["href"].value = "http://myproxy.com/?url=#{CGI.escape link.attributes["href"].value}"
#        http://#{environment.default_hostname}/#{relative_path[1]}
      
      
      body = doc.to_s
      sender = Person.find(article.author_id)
      members = article.profile.members
      emails = []
      members.each{ |m|
        emails.push(m.user.email)
      }
      mail(
        content_type: 'text/html',
        to: emails,
        from: "#{article.author_name} <#{sender.contact_email}>",
        reply_to: article.author.user.email,
        subject: "[Artigo] " + article.title,
        body: body
#        body: set_absolute_path(article.body, article.environment)
      )
    end

    def set_absolute_path(body, environment)
      parsed = Hpricot(body.to_s)
      parsed.search('img[@src]').map { |i| change_element_path(i, 'src', environment) }
      parsed.search('a[@href]').map { |i| change_element_path(i, 'href', environment) }
      parsed.to_s
    end

    def change_element_path(el, attribute, environment)
      fullpath = /^http/.match(el[attribute])
      if not fullpath
        relative_path = /\/?(.*)/.match(el[attribute])
        el[attribute] = "http://#{environment.default_hostname}/#{relative_path[1]}"
      end
    end
  end
end
