#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/twurl'

Twurl::Stream.run('nba', '/root/.twurlrc')
