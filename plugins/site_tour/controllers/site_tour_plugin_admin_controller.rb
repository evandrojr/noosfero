require 'csv'

class SiteTourPluginAdminController < PluginAdminController

  no_design_blocks

  def index
    settings = params[:settings]
    settings ||= {}

    @settings = Noosfero::Plugin::Settings.new(environment, SiteTourPlugin, settings)
    @settings.actions_csv = convert_to_csv(@settings.actions)

    if request.post?
      @settings.actions = convert_from_csv(settings[:actions_csv])
      @settings.settings.delete(:actions_csv)

      @settings.save!
      session[:notice] = 'Settings succefully saved.'
      redirect_to :action => 'index'
    end
  end

  protected

  def convert_to_csv(actions)
    CSV.generate do |csv|
      (@settings.actions||[]).each { |action| csv << action.values }
    end
  end

  def convert_from_csv(actions_csv)
    CSV.parse(actions_csv).map do |action|
      {:language => action[0], :group_name => action[1], :selector => action[2], :description => action[3]}
    end
  end

end
