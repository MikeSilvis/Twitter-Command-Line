require 'rubygems'
require 'jumpstart_auth'
require 'bitly'
require 'ap'

class JSTwitter
  	attr_accessor :client

	def initialize
    	puts "Initializing..."
    	@client = JumpstartAuth.twitter
  	end

	def run

		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' 	then puts "Goodbye!"
				when "t" 	then tweet(parts[1..-1].join(" "))
				when 'dm' 	then dm(parts[1], parts[2..-1].join(" "))	
				when 'flt' 	then friends
				when 's' 	then shorten
				when 'turl' then tweet_with_url(parts[1..-1])
				else
				  puts "Sorry, I don't know how to (#{command})"
			end		
				
		end	
	end

	def tweet(message)
		if message.length < 140
			@client.update(message)
			puts "Message successfully sent"
		else
			puts "rutrow"
		end
	end		

	def dm(target,message)
		puts "Trying to send #{target} this direct message:"
		puts message
		new_message = "d " + target + " " + message
		if dmcheck == true
			tweet(new_message)
		else
			puts "You can only dm people that follow you"
		end
	end

	def followers_list
		@folllowers = @client.followers.collect { |follower| follower.screen_name}
	end

	def dmcheck(target)
		followers_list.include? target
	end

	def spam_my_friends(message) ## Not tested. I don't want to spam all of my personal followers.
		follower_array = followers_list

		follower_array.each do |follower|
			dm(follower,message)
		end
	end
	def tweet_with_url(message)
		tweet(message[1..-2].join(" ") + shorten(message[-1]))
	end
	def friends_last_tweet ## NOt Tested. Needs sort algorithm
		friends
		#puts friends
		#puts friends.to_s
		# friends.each do |friend|
		# 	puts friend.screen_name + "said..."
		# 	puts friend.status.text
		# 	timestamp = friend.status.created_at
		# 	tweet_date = Date.parse(timestamp)
		# 	puts tweet_date.strftime("%A, %b %d")
		# end
	end

	def friends
		friends_array = []
		friends_hash = @client.friends
		friends_hash.each do |friend|
			friends_hash = Hash[:screen_name => friend.attrs["screen_name"], :status => friend.attrs["status"]["text"], :status_time => friend.attrs["status"]["created_at"]]
			friends_array << friends_hash
		end
		friends_array
	end

	def shorten(original_url)
		puts "Shortening this URL: #{original_url}"

		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		bitly_shorten = bitly.shorten('http://jumpstartlab.com/courses/ruby/').short_url

		puts "Results is #{bitly_shorten}"

		return bitly_shorten
	end	
end
jst = JSTwitter.new
jst.run