class Noosfero::API::CaptchaSessionStore

  attr_accessor :data
  attr_reader :private_token

  def self.create
    key = SecureRandom.hex
    store = Noosfero::API::CaptchaSessionStore.new(key)
    Rails.cache.write(store.private_token, store, expires_in: 300)
    return store
  end

  def initialize(key)
    @private_token = key
  end

  def self.get(key)
    Rails.cache.fetch(key)
  end

  def store
    Rails.cache.write(@private_token, self)
  end

  def destroy
    Rails.cache.delete(@private_token)
  end


end
