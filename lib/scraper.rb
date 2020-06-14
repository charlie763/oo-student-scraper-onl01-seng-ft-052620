require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_info = doc.css(".student-card")
    student_info.map do |nok_obj|
    	student_hash = {}
    	student_hash[:name] = nok_obj.css(".student-name").text
    	student_hash[:location] = nok_obj.css(".student-location").text
    	student_hash[:profile_url] = nok_obj.css("a")[0].values[0]
    	student_hash
    end
  end

  def self.img_url_to_sym(url)
  	sym = url[/\w+\-icon/].delete_suffix("-icon").to_sym
  	sym == :rss ? :blog : sym
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_hash = {}
    doc.css(".social-icon-container a").each do |nok_obj|
    	social_media_url = nok_obj.values[0]
    	img_url = nok_obj.css("img").attribute("src").value
    	profile_hash[img_url_to_sym(img_url)] = social_media_url
    end

    profile_hash[:profile_quote] = doc.css(".profile-quote").text
    profile_hash[:bio] = doc.css(".description-holder p").text

    profile_hash
  end

end

