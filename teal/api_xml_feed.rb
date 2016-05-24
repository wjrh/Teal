require 'nokogiri'
require 'tilt'
require 'tilt/redcarpet'

module Teal
	class App < Sinatra::Base

   	get "/programs/:shortname/feed.xml/?" do
			program = Program.where(shortname: params['shortname']).first
			halt 404 if program.nil?
			content_type 'text/xml'
			program.episodes.sort! { |a,b| a.pubdate <=> b.pubdate }
			redirect program.redirect_url if not (program.redirect_url.nil? or program.redirect_url.eql?(""))
			return generatefeed(program)
		end

		def generatefeed(program)
		feed = Nokogiri::XML::Builder.new do |xml|
		       xml.rss('xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd", 'version' => '2.0') do

		         #insert program information
		         xml.channel do
		           xml.title program["name"]
		           xml.link "http://wjrh.org/#{program["shortname"]}"
		           xml['itunes'].image('href' => program['image'])
		           
		           xml.copyright program["copyright"] if program ["copyright"]
		           xml['itunes'].subtitle program["subtitle"] if program["subtitle"]
		           xml['itunes'].author program["author"] if program["author"]
		           xml['itunes'].explicit program["explicit"] if program["explicit"]
		           xml.language program["language"] if program["language"]

		           if program["itunes_categories"]
			           program["itunes_categories"].each do |category|
			           	xml['itunes'].category("text" => category) 
			           end
			         end

		           if program['description']
		             xml['itunes'].summary {
		               xml.cdata Tilt['markdown'].new { program['description'] }.render
		             }
		             xml.description {
		               xml.cdata Tilt['markdown'].new { program['description'] }.render
		             }
		           end

		           if program.episodes
		           #insert each episode in this episode
			           program.episodes.each do |episode|
			             xml.item do
			               xml.title episode['name']
			               xml['itunes'].author program['author']
			               xml['itunes'].explicit episode["explicit"] if episode["explicit"]
			               xml.guid episode["guid"] ||= episode["id"]
			               if episode['image']
			               	xml['itunes'].image("href" => episode['image'])
			               else
			               	xml['itunes'].image("href" => program['image'])
			               end
			               xml.pubDate episode["pubdate"].rfc2822
			               xml['itunes'].duration episode['length']
			               
			               if episode['description']
			                 xml['itunes'].subtitle {
			                  xml.cdata Tilt['markdown'].new { episode['description'] }.render
			                 }
			                 xml['itunes'].summary {
			                  xml.cdata Tilt['markdown'].new { episode['description'] }.render
			                 }
			               end

			               xml.enclosure("url" => episode["audio_url"], "length" => episode["length"], "type" => episode["type"])
			        
			             end
			           end 
			         end
		         end
		       end
		     end
	     return feed.to_xml
		end

	end
end
