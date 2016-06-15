require 'thread'

module Teal
	# Class that makes the calls to Server Sent Events (SSE) channels on NGINX
	class Live
		#sleep and then push the event
		def self.publish(event, program, delay)
			Thread.new{ publishAsync(event, program, delay) }
    end

    def self.publishAsync(event, program, delay)

  		sleep(delay.to_i)

			uri = URI("http://nginx:23021/programs/#{program.shortname}/live/publish")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = event.to_json
      response = http.request(request)

      program.organizations.each do |org|
      	uri = URI("http://nginx:23021/organizations/#{org}/live/publish")
	      http = Net::HTTP.new(uri.host, uri.port)
	      request = Net::HTTP::Post.new(uri.request_uri)
	      request.body = event.to_json
	      response = http.request(request)
      end

			uri = URI("http://live-manager:8080/programs/#{program.shortname}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = event.to_json
      response = http.request(request)

      program.organizations.each do |org|
      	uri = URI("http://live-manager:8080/organizations/#{org}")
	      http = Net::HTTP.new(uri.host, uri.port)
	      request = Net::HTTP::Post.new(uri.request_uri)
	      request.body = event.to_json
	      response = http.request(request)
      end
    end
	end
end
