class DspacePlugin::Item

  attr_accessor :id, :name, :author, :issue_date, :abstract, :description, :uri, :files

  def initialize
    self.files = []
  end

end
