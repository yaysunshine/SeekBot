require 'ringcentral_sdk'

class Number

	def initialize()
		@rcsdk = RingCentralSdk::Sdk.new(
		  "~", 
		  "~", 
		  RingCentralSdk::Sdk::RC_SERVER_SANDBOX
		)
  end

	def auth
		@rcsdk.platform.authorize("+18024486712", "101", "~")
	end

	def get_log
		@past_message = ""
		response = @rcsdk.platform.client.get do |req|
		  req.url 'account/~/extension/~/message-store?messageType=SMS&readStatus=Unread'
		end
		incoming_message = response.body["records"][0]["subject"] ## actual text message
	end

	def send_text(text)
		@rcsdk.platform.client.post do |req|
		  req.url 'account/~/extension/~/sms'
		  req.headers['Content-Type'] = 'application/json'
		  req.body = {
		    :from =>   { :phoneNumber => '' },
		    :to   => [ { :phoneNumber => ''} ],
		    :text => text
		  }
		end
		p text
	end
end