class OauthClientPlugin::Provider < Noosfero::Plugin::ActiveRecord

  belongs_to :environment

  validates_presence_of :identifier, :name, :strategy
  validates_uniqueness_of :identifier, :scope => :environment_id

  acts_as_having_image
  acts_as_having_settings :field => :options

  settings_items :client_id, :type => :string
  settings_items :client_secret, :type => :string
  settings_items :client_options, :type => Hash

  attr_accessible :identifier, :name, :environment, :strategy, :client_id, :client_secret, :enabled, :client_options, :image_builder

  scope :enabled, :conditions => {:enabled => true}

  acts_as_having_image

end
