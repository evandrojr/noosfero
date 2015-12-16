require File.dirname(__FILE__) + '/test_helper'

class SessionStoreTest < ActiveSupport::TestCase

  should 'create a session store without client key' do
    store = Noosfero::API::SessionStore.create
    assert_not_nil store
    private_token = store.private_token
    assert_not_nil private_token
    key = store.key
    assert_not_nil key
    assert_equal key, private_token
  end

  should 'create a session store with client key' do
    store = Noosfero::API::SessionStore.create("mykey")
    assert_not_nil store
    private_token = store.private_token
    assert_not_nil private_token
    key = store.key
    assert_not_nil key
    assert_equal key, "mykey##{private_token}"
  end

  should 'get a session store with client key' do
    store = Noosfero::API::SessionStore.create("mykey")
    retrieved = Noosfero::API::SessionStore.get(store.key)
    assert_not_nil retrieved
  end

  should 'not get a destroyed session store with client key' do
    store = Noosfero::API::SessionStore.create("mykey")
    store.destroy
    retrieved = Noosfero::API::SessionStore.get(store.key)
    assert_nil retrieved
  end

  should 'store data in session store' do
    store = Noosfero::API::SessionStore.create("mykey")
    store.data = [1, 2]
    ## Put it back in cache
    store.store
    retrieved = Noosfero::API::SessionStore.get(store.key)
    assert_equal [1,2], retrieved.data
  end

end