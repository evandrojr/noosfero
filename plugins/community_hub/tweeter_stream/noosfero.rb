#!/usr/bin/env ruby
require 'rubygems'        # if you use RubyGems

require File.dirname(__FILE__) + '/lib/twurl'

Twurl::Stream.run('popcorntime,time4popcorn', '/root/.twurlrc')
