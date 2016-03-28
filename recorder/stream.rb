module Recorder
	class Stream

		attr_accessor :episode_id,		# episode to upload to after recording
									:user_key,			# who to upload as after recording
									:stream_url,		# url to record from
									:delay,					# before taking action in starting and stopping
									:thread					# pid of the recording instance
	end
end