#!/usr/bin/env ruby
require 'rubygems'        # if you use RubyGems

require File.dirname(__FILE__) + '/lib/twurl'

Twurl::Stream.run(Article.last, 1, '#nba', '/home/00838716598/participa/noosfero/plugins/community_hub/tweeter_stream/config/twurlrc')
