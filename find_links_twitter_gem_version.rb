=begin
	This version is based on the twitter gem which doesn't return reliable enough results. I've included it in here for reference.
=end
require 'uri'

begin
  require 'rubygems'
  gem 'twitter' , ">= 1.1.2" 
  require 'twitter' 
rescue LoadError
  puts "This script requires version 1.1.2 of the twitter gem. Please install it using \"gem install twitter\""
  exit
end

def validated_input
  raise "USAGE:\nRun the script by passing a single alphanumeric hashtag as the argument.\neg. ruby find_links.rb radiohead" unless (ARGV.length == 1 && ARGV[0] =~ /^[\w\d]+$/)
  ARGV[0]
end

def output_uniq_links_for_hashtag 
  search = Twitter::Search.new
  results = search.hashtag(validated_input).per_page(100).result_type("recent").fetch.map{|result| result[:text]}.join
  urls = URI.extract(results).delete_if{|url| !(url =~ /^http/i)}.uniq
  
  line_number = 1
  urls.each do |link|
    puts "#{line_number}. #{link}" 
    line_number+=1
  end

  puts "No links found" if line_number == 1
  
  rescue => err
  	puts err
end

output_uniq_links_for_hashtag