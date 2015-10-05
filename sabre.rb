require 'httparty'
require 'uri'

class Sabre
    include HTTParty

    def get_airports(city)
    	response = self.class.get(
	    	"https://api.test.sabre.com/v1/lists/supported/cities/SFO/airports",
	    	:headers => { "Authorization" => "Bearer  "}
    	)
    end

    def top_destinations(origin_city)
    	response = self.class.get(
    		"https://api.test.sabre.com/v1/lists/top/destinations?origin=#{origin_city}&topdestinations=10&lookbackweeks=2",
    		:headers => { "Authorization" => "Bearer  "}
    	)
    	result = []
    	y = response.parsed_response["Destinations"]
    	result.push(y[0]["Destination"]["DestinationLocation"])
			result.push(y[1]["Destination"]["DestinationLocation"])
			result.push(y[2]["Destination"]["DestinationLocation"])
			result.push(y[3]["Destination"]["DestinationLocation"])
			result.push(y[4]["Destination"]["DestinationLocation"])
			a = "The top 5 destinations going out from your home airport are " + result.join(", ")
			a
    end

    # Finds the 20 lowest published fares available for a given destination. Destination is always required.
    def flights_to(destination_city)
    	response = self.class.get(
    		"https://api.test.sabre.com/v1/shop/flights/cheapest/fares/#{destination_city}?pointofsalecountry=US",
    	:headers => { "Authorization" => "Bearer  "}
    	)
    	result = []
    	response.parsed_response["FareInfo"].each_with_index do |item, index|
    	  currency = item["CurrencyCode"]
    		airline = item["LowestFare"]["AirlineCodes"][0]
			  price = item["LowestFare"]["Fare"]
			  destination = item["OriginLocation"]
			  date = item["DepartureDateTime"]
			  result.insert(index, "Flight to #{destination} with #{airline}, $#{price} #{currency}, on #{date}")
    	end
    	result.join("   ")
    end

    #Finds the lowest nonstop fare and the lowest overall fare on future dates of travel.
    def lead_price(origin, destination, length)
    	response = self.class.get(
    		"https://api.test.sabre.com/v2/shop/flights/fares?origin=#{origin}&destination=#{destination}&lengthofstay=#{length}&pointofsalecountry=US",
    		:headers => { "Authorization" => "Bearer  "}
    	)
    end

    # Find flights with origin, destination, departuredate, returndate
    def find_trip(origin, destination, departuredate, returndate)
    	response = self.class.get(
    		"https://api.test.sabre.com/v1/shop/flights?origin=#{origin}&destination=#{destination}&departuredate=#{departuredate}&returndate=#{returndate}&onlineitinerariesonly=N&limit=10&offset=1&eticketsonly=N&sortby=totalfare&order=asc&sortby2=departuretime&order2=asc&pointofsalecountry=US",
    		:headers => { "Authorization" => "Bearer  "}
			)
    end

end
