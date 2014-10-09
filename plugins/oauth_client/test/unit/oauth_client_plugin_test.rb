require File.dirname(__FILE__) + '/../test_helper'

class OauthClientPluginTest < ActiveSupport::TestCase

  def setup
    @plugin = OauthClientPlugin.new
    @params = {}
    @plugin.stubs(:context).returns(self)
    @environment = Environment.default
  end

  attr_reader :params, :plugin, :environment

  should 'has extra contents for login' do
    assert plugin.login_extra_contents
  end

  should 'has no signup extra contents if no provider was enabled' do
    assert_equal '', instance_eval(&plugin.signup_extra_contents)
  end

  should 'has signup extra contents if there is enabled providers' do
    params[:user] = {:oauth_providers => [:provider]}
    expects(:render).with(:partial => 'account/oauth_signup').once
    instance_eval(&plugin.signup_extra_contents)
  end

  should 'list enabled providers' do
    settings = Noosfero::Plugin::Settings.new(environment, OauthClientPlugin)
    providers = {:test => {:enabled => true}, :test2 => {:enabled => false}}
    settings.set_setting(:providers, providers)
    assert_equal({:test => {:enabled => true}}, plugin.enabled_providers)
  end

  should 'define before filter for account controller' do
    assert plugin.account_controller_filters
  end

  should 'raise error if oauth email was changed' do
    request = mock
    stubs(:request).returns(request)
    request.expects(:post?).returns(true)

    oauth_data = mock
    info = mock
    oauth_data.stubs(:info).returns(info)
    info.stubs(:email).returns('test@example.com')
    stubs(:session).returns({:oauth_data => oauth_data})

    params[:user] = {:email => 'test2@example.com'}
    assert_raises RuntimeError do
      instance_eval(&plugin.account_controller_filters[:block])
    end
  end

  should 'do not raise error if oauth email was not changed' do
    request = mock
    stubs(:request).returns(request)
    request.expects(:post?).returns(true)

    oauth_data = mock
    info = mock
    oauth_data.stubs(:info).returns(info)
    info.stubs(:email).returns('test@example.com')
    stubs(:session).returns({:oauth_data => oauth_data})

    params[:user] = {:email => 'test@example.com'}
    instance_eval(&plugin.account_controller_filters[:block])
  end

  should 'do not raise error if oauth session is not set' do
    request = mock
    stubs(:request).returns(request)
    request.expects(:post?).returns(true)
    stubs(:session).returns({})
    instance_eval(&plugin.account_controller_filters[:block])
  end

  should 'do not raise error if it is not a post' do
    request = mock
    stubs(:request).returns(request)
    request.expects(:post?).returns(false)
    instance_eval(&plugin.account_controller_filters[:block])
  end

end
