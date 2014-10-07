class DspacePlugin::Item

  include DspacePlugin::ItemHelper

  attr_accessor :id, :name, :author, :issue_date, :abstract, :description, :uri, :files, :mimetype

  def initialize
    self.files = []
  end

end
