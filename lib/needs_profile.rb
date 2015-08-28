module NeedsProfile

  module ClassMethods
    def needs_profile
      before_filter :load_profile
    end
  end

  def self.included(including)
    including.send(:extend, NeedsProfile::ClassMethods)
  end

  def boxes_holder
    profile || environment # prefers profile, but defaults to environment
  end

  def profile
    @profile
  end

  protected

  def load_profile
    if params[:profile]
      params[:profile].downcase!
      @profile ||= environment.profiles.where(identifier: params[:profile]).first
    end

    if @profile
      profile_hostname = @profile.hostname
      if profile_hostname && profile_hostname != request.host
        if params[:controller] == 'content_viewer'
          params[:profile] = nil
        else
          params.delete(:profile)
        end
        redirect_to(Noosfero.url_options.merge(params).merge(:host => profile_hostname))
      end
    else
      render_not_found
    end
  end

end
