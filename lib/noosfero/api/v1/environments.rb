module Noosfero
  module API
    module V1
      class Environments < Grape::API
        before { authenticate! }
  
        resource :environment do
  
          # Get environment object
          #
          # Example Request:
          #  GET /environment
          get do
            present environment, :with => Entities::Environment
          end
  
          desc "Return the person information"
          get '/signup_person_fields' do
            present environment.signup_person_fields
          end
  
        end
  
      end
    end
  end
end
