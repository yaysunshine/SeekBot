require_relative 'bot'
require_relative 'ringcentral'
require_relative 'sabre'

number = Number.new() 
bot = Bot.new
sabre = Sabre.new()

	## Auth with RingCentral before every request
20.times do
	number = Number.new() 

	number.auth
	## The body of the last text message received by Ring Central
	text_response = number.get_log


	@home_airport = "SFO"

		if text_response["sabre"]
			number.send_text("What would you like to do with Sabre API? You can look up top destinations, cheap flights to certain locations, or find an affordable trip in a specific date range.")
			number.send_text("Please reply with the keywords Top Destinations, Cheap Flights, or Trip Search.")
		end
		if text_response["home airport"]
			@home_airport = text_response[2]
			number.send_text("Got it, your home airport is #{@home_airport}")
		end
		if text_response["destination airport"]
			@destination_airport = text_response[2]
			number.send_text("Your destination airport is #{@destination_airport}")
		end
		if text_response["Top Destinations"]
			if @home_airport
				number.send_text(sabre.top_destinations(@home_airport))
				sleep(2)
				number.send_text("If you would like to find information about flights, just say Cheap Flights from <airport name>!")
			else
				number.send_text("What airport are you flying out of? Use syntax: home airport <airport code>. If you don't know the airport code, reply with: Search <city>")
			end
		end
		if text_response["Cheap Flights"]
			@destination_airport = "LAX"
			if @destination_airport
				number.send_text(sabre.flights_to(@destination_airport))
			else
				number.send_text("We need to know your destination airport. Use syntax: destination airport <airport code>. If you don't know the airport code, reply with: Search <city>")
			end
		end


		## We parse the text response to remove special chars
		## and send it to the bot API
		## the response is received
		x = bot.talk(text_response.gsub(/[^0-9a-z ]/i, ''))
		bot_response = x["responses"][0] ## Pull out the actual response

		## Parse this for special chars
		## then send it as a text
		number.send_text(bot_response.gsub(/[^0-9a-z ]/i, ''))

		sleep(30)
end




