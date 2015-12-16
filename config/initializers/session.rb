require File.join(Rails.root,'app/models/session')

ActionDispatch::Reloader.to_prepare do
  require_relative '../../app/models/session'
  ActionDispatch::Session::ActiveRecordStore.session_class = Session
end

