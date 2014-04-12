require 'rubygems'
require 'koala'
require 'json'

#@graph = Koala::Facebook::API.new('CAACEdEose0cBADWfQZB39lBDksRvjeJGGrkM3dYKTrWEG3G0m8eZCpq2Vf4dNnpAeKML3yxcTmxQ4ZAJfUcNMROrWFlonrkMiPMQlKcqLxSs9GhMWmMJvjHgPrhXJFIvBLD3Mlf0BIF89SLXlNFQj56DxtKkJpzZA8gzh0HCDGqsZA0b6kgPjPqJ2UIQsBZA4ZD')
@graph = Koala::Facebook::API.new('CAAEhsewl0ZAcBAHhipXszZCURSwWLmgvceDbs9mB5baJdLriFxYMEzywmF2fvZBuThuA2Mm7QF8wPd3E6R5pVqVEnC2VhcBb4VrfAnkZC73ZC5g1NRUnKZCB2e6CaRiUBDatR2nf505PeKp7Aj5XxvTdfSqdZCsXxQFYZApPNSUUgkUWm6HwL4rp21MRJXb612sZD')

feed = @graph.get_connections("participabr", "posts")

feed.each {|f| p f } 
next_feed = feed.next_page
