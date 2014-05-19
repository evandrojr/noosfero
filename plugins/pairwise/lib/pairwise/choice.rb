class Pairwise::Choice < ActiveResource::Base
  extend Pairwise::Resource

  self.element_name = "choice"
  self.format = :xml

end
