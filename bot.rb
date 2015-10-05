require 'httparty'
require 'uri'


class Bot
	include HTTParty

	def talk(text_in)
		p text_in
		response = self.class.post(URI.parse(URI.encode("https://aiaas.pandorabots.com/talk/~/seek/?user_key=~&input=#{text_in}")))
	end

	def test
		self.class.get("https://aiaas.pandorabots.com/bot/~?user_key=~")
	end
end
