class Pairwise::Visitor < ActiveResource::Base
  extend Pairwise::Resource

  self.element_name = "visitor"
  self.format = :xml

end
