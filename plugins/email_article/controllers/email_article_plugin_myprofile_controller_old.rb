require 'nokogiri'

class EmailArticlePluginMyprofileController < MyProfileController

  needs_profile

  def send_email
    if user.is_admin?(profile)
      article = profile.articles.find(params[:id])
      #EmailArticlePluginMyprofileController::Sender.content(article).deliver
      Sender.content(article)
      render :text => "Email sent to queue"
    else
      render :status => :forbidden, :text => "Forbidden user"
    end
  end

  class Sender
    def self.content(article)
      source = article.author.user.person
      mail = Mailing.new
      mail.
      #  mailing = create(Mailing, :source => article.author.user.person, :subject => 'Hello', :body => 'We have some news', :person => article.author.user.person)
    end

    def absolute_url? url
      url.start_with?('http') || url.start_with?('ftp')
    end
  end


  class Sender < ActionMailer::Base
    def content(article)
      doc = Nokogiri::HTML(article.body)
      doc.css("a").each do |link|
        if !link.attribute("href").nil? and !absolute_url?(link.attribute("href").value)
          relative_path = link.attribute("href").value
          if relative_path.starts_with?('/')
            relative_path[0]=''
          end
          link.attribute("href").value = "http://#{article.environment.default_hostname}/#{relative_path}"
        end
      end

      doc.css("img").each do |link|
        unless link.attribute("src").nil? and absolute_url?(link.attribute("src").value)
          relative_path = link.attribute("src").value
          link.attribute("src").value = "http://#{article.environment.default_hostname}/#{relative_path}"
        end
      end

#        link.attributes["href"].value = "http://myproxy.com/?url=#{CGI.escape link.attributes["href"].value}"
#        http://#{environment.default_hostname}/#{relative_path[1]}


      body = doc.to_html
      sender = Person.find(article.author_id)
      members = article.profile.members
      emails = []
      members.each{ |m|
        emails.push(m.user.email)
      }

    #  mailing = create(Mailing, :source => article.author.user.person, :subject => 'Hello', :body => 'We have some news', :person => article.author.user.person)

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
end



end
