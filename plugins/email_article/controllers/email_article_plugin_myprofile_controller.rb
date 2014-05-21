class EmailArticlePluginMyprofileController < MyProfileController

  needs_profile

  def send_email
    if user.is_admin?(profile)
      article = Article.find(params[:id])
      EmailArticlePluginMyprofileController::Sender.deliver_mail(article)
      render :text => "Email sent to queue"
    else
      render :status => :forbidden, :text => "Forbidden user"
    end
  end

  class Sender < ActionMailer::Base
    def mail(article)
      members = article.profile.members
      emails = []
      members.each{ |m|
        emails.push(m.user.email)
      }
      content_type 'text/html'
      recipients emails
      from "#{article.author.user.name} <#{article.author.user.email}>"
      reply_to article.author.user.email
      subject "[Artigo] " + article.title
      body set_absolute_path(article.body, article.environment)
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