## A session store for the API. It can store
## generic data on the Rails Cache to simulate
## a stateful session for API methods
class Noosfero::API::SessionStore

  ## A generic data value to allow storing any 
  ## value within this SessionStore
  attr_accessor :data
  ## The user private_token associated with this SessionStore
  attr_reader :private_token
  ## The key for this SessionStore in the Rails Cache
  attr_reader :key

  ## Call this method to create and store a SessionStore
  ## in Rails Cache. The SessionStore is returned. The
  ## client_key parameter, if used, will uniquely identify 
  ## this SessionStore in Rails Cache, along with the user
  ## private_token in the form: client_key#private_token
  def self.create(client_key = nil)
    private_token = SecureRandom.hex
    store = Noosfero::API::SessionStore.new(client_key, private_token)
    Rails.cache.write(store.key, store, expires_in: 300)
    return store
  end

  ## Creates a new SessionStore. Do not use directly in cliente code.
  ## Please use the self.create method instead
  def initialize(client_key, private_token)
    ## Creates the key to store this object in Rails Cache
    key = "#{client_key}#" if client_key
    key = "#{key}#{private_token}"
    @key = key
    @private_token = private_token
  end

  ## Returns the SessionStore in Rails Cache associated
  ## with the given key
  def self.get(key)
    Rails.cache.fetch(key)
  end

  ## Stores this SessionStore in Rails Cache using the
  ## key attribute as the unique identifier
  def store
    Rails.cache.write(@key, self)
  end

  ## Remove this session store from Rails Cache
  def destroy
    Rails.cache.delete(@key)
  end

end
