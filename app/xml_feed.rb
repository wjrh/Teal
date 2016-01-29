require 'nokogiri'
require 'tilt'
require 'tilt/redcarpet'

module Teal
	class App < Sinatra::Base

   	get "/programs/:shortname/feed/?" do
			program = Program.where(shortname: params['shortname']).first
			halt 404 if program.nil?
			program.episodes.sort! { |a,b| a.pubdate <=> b.pubdate }
			return generatefeed(program)
		end

		def generatefeed(program)
	     feed = Nokogiri::XML::Builder.new do |xml|
				 xml.rss('xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd") do
					 xml.channel do
				  	 xml.title program["name"]
					   xml.link "http://wjrh.org/#{program["shortname"]}"
						 xml.copyright program["copyright"]
						 xml['itunes'].subtitle program["subtitle"]
						 xml['itunes'].author program["creators"].join(", ")
						 if not program['description'].nil?
							 xml['itunes'].summary {
								 xml.cdata Tilt['markdown'].new { program['description'] }.render
							 }
							 xml.description {
								 xml.cdata Tilt['markdown'].new { program['description'] }.render
							 }
						 end
						 xml['itunes'].image('href' => "http://wjrh.org/vbb/logo2.jpg")
						 program.episodes.each do |episode|
							 xml.item do
								 xml.title episode['name']
								 xml['itunes'].author program['creators'].join(", ")
								 if not episode['description'].nil?
							 		 xml['itunes'].subtitle {
										xml.cdata Tilt['markdown'].new { episode['description'] }.render
							 	 	 }
							 		 xml['itunes'].summary {
								 		xml.cdata Tilt['markdown'].new { episode['description'] }.render
								   }
					 			 end
								 xml['itunes'].image("href" => episode['image'])
								 episode.medias.each do |media|
									 xml.enclosure("url" => media["url"], "length" => media["length"], "type" => media["type"])
								 end
								 xml.guid episode["guid"] ||= episode["id"]
								 xml.pubDate episode["pubdate"].rfc2822
								 xml['itunes'].duration episode.medias[0]['length']
							 end
						 end 
					 end
				 end
			 end
		 return feed.to_xml
		end

	end
end
