#!/usr/bin/env ruby
=begin
= find_links.rb
	find_links.rb is a twitter client script that searches the 100 most recent tweets with links, for a supplied hashtag.
	Once the tweets with the given hashtag are found, the script prints a numbered list of unique links found in the tweets.
	The script ignores links to hashtags and twitter profiles and tries to print only the links that were most likely entered by the user.
		
== Requirements       
  	find_links.rb has been tested and works on MacOSX 10.6.7 using the following ruby implementations: 
  	ruby 1.8.7, ruby 1.9.2, jruby 1.6.0(In both 1.8 and 1.9 modes).
  	I expect it to work on other platforms without modification.
  	
  	find_links.rb depends on version 1.4.4 or greater of the nokogiri gem. 
  	Install with "gem install nokogiri". For more info on nokogiri, Visit http://www.nokogiri.org
	  
	
== Usage  
	Run the script by passing a single alphanumeric hashtag as the argument. eg. 
	ruby find_links.rb radiohead
	
== Copyright
	
Copyright (c) 2011 Joey Adarkwah
=end

require 'cgi'
require 'open-uri'

begin
  require 'rubygems'
  gem 'nokogiri' , ">= 1.4.4" 
  require 'nokogiri' 
rescue LoadError
  puts "This script requires version 1.4.4 of the nokogiri gem. Please install it using \"gem install nokogiri\""
  exit
end

def validated_input
  raise "USAGE:\nRun the script by passing a single alphanumeric hashtag as the argument.\neg. ruby find_links.rb radiohead" unless (ARGV.length == 1 && ARGV[0] =~ /^[\w\d]+$/)
  ARGV[0]
end

def output_uniq_links_for_hashtag 
  twitter_search_url = "http://search.twitter.com/search.atom?q=%23#{validated_input}%20filter%3Alinks&rpp=100"
  atom_feed = Nokogiri::XML(open(twitter_search_url)) do |config|
    config.strict.noblanks
  end

  content_elements = atom_feed.xpath("//xmlns:content/text()")
  unescaped_content_elements = CGI::unescapeHTML(content_elements.to_s)
  urls = URI.extract(unescaped_content_elements)

  line_number = 1;
  urls.delete_if{|url| (!(url =~ /^http/i) || (url =~ /^http:\/\/(search.)?twitter.com\//i))}.uniq.each do |link|
    puts "#{line_number}. #{link}" 
    line_number+=1
  end
  
  puts "No links found" if line_number == 1
  
  rescue => err
  	puts err
end

output_uniq_links_for_hashtag