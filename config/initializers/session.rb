require File.join(Rails.root,'app/models/session')

ActionDispatch::Reloader.to_prepare do
  ActiveRecord::SessionStore.session_class = Session
end

