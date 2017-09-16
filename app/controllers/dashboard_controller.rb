require 'uri'
require 'net/http'

class DashboardController < ApplicationController
	@@jennifer = @@john = @@jessica = @@james = true

  def kitchen_sink
    render :kitchen_sink, layout: "kitchen"
  end
  def kitchen8_sink
    render :kitchen8_sink, layout: "kitchen8"
  end

  def index
  	@@jennifer = get_current_state('jennifer')
  	@@john = get_current_state('john')
  	# @@james = get_current_state('james')
  	# @@jessica = get_current_state('jessica')
  	@jennifer = @@jennifer
  	@john = @@john
  	@james = @@james
  	@jessica = @@jessica
  	render 
  end

  def jennifer
  	if request.get?
  		@jennifer = @@jennifer
	 	puts "jennifer is #{@@jennifer} in get"
	 	render partial: "shared/jennifer"
	elsif request.post?
		puts "jennifer was #{@@jennifer} in post"
	 	@@jennifer = !@@jennifer
	 	@jennifer = @@jennifer
	 	puts "jennifer is #{@@jennifer} in post"
	 	render :js => "$('#jennifer-button').load('/jennifer');"
	end
	 		
  	url = URI("https://use1-wap.tplinkcloud.com/?token=#{ENV['TP_LINK_TOKEN']}")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Post.new(url)
	request["content-type"] = 'application/json'
	request["cache-control"] = 'no-cache'
	request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{ENV['TP_LINK_JENNIFER']}\", \"requestData\": \"{\\\"system\\\":{\\\"get_sysinfo\\\":{}}}\" }}"
	
	response = http.request(request)
	state = JSON.parse(JSON.parse(response.body)["result"]["responseData"])["system"]["get_sysinfo"]["relay_state"]

	# next_state = state == 1 ? 0 : 1
	# request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{ENV['TP_LINK_JENNIFER']}\", \"requestData\": \"{\\\"system\\\":{\\\"set_relay_state\\\":{\\\"state\\\":#{next_state}}}}\" }}"
 #  	http.request(request)
 	# @jennifer = @@jennifer
 	# puts "jennifer is #{@@jennifer} in get"
 	# render partial: "shared/jennifer"
  end

  def john
 #  	url = URI("https://use1-wap.tplinkcloud.com/?token=#{ENV['TP_LINK_TOKEN']}")

	# http = Net::HTTP.new(url.host, url.port)
	# http.use_ssl = true
	# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	# request = Net::HTTP::Post.new(url)
	# request["content-type"] = 'application/json'
	# request["cache-control"] = 'no-cache'
	# request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{ENV['TP_LINK_JOHN']}\", \"requestData\": \"{\\\"system\\\":{\\\"get_sysinfo\\\":{}}}\" }}"
	
	# response = http.request(request)
	# state = JSON.parse(JSON.parse(response.body)["result"]["responseData"])["system"]["get_sysinfo"]["relay_state"]

	# next_state = state == 1 ? 0 : 1
	# request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{ENV['TP_LINK_JOHN']}\", \"requestData\": \"{\\\"system\\\":{\\\"set_relay_state\\\":{\\\"state\\\":#{next_state}}}}\" }}"
 #  	http.request(request)
 	@john = !@john
  end

  def james
	url = URI("http://192.168.1.165/api/#{ENV['HUE_TOKEN']}/lights/3")

	http = Net::HTTP.new(url.host, url.port)

	request = Net::HTTP::Get.new(url)
	request["cache-control"] = 'no-cache'

	response = http.request(request)
	state = JSON.parse(response.body)["state"]["on"]

	next_state = !state

	url = URI("http://192.168.1.165/api/#{ENV['HUE_TOKEN']}/lights/3/state")
	request = Net::HTTP::Put.new(url)
	request["content-type"] = 'application/json'
	request["cache-control"] = 'no-cache'
	request.body = "{\n\t\"on\": #{next_state}\n}"
	http.request(request)
  end

  def jessica
  	url = URI("http://192.168.1.165/api/#{ENV['HUE_TOKEN']}/lights/1")

	http = Net::HTTP.new(url.host, url.port)

	request = Net::HTTP::Get.new(url)
	request["cache-control"] = 'no-cache'

	response = http.request(request)
	state = JSON.parse(response.body)["state"]["on"]

	next_state = !state

	url = URI("http://192.168.1.165/api/#{ENV['HUE_TOKEN']}/lights/1/state")
	request = Net::HTTP::Put.new(url)
	request["content-type"] = 'application/json'
	request["cache-control"] = 'no-cache'
	request.body = "{\n\t\"on\": #{next_state}\n}"
	http.request(request)
  end

  def tv
  end

  private

  def get_current_state(device)
  	if ["jennifer", "john"].include? device
	  	url = URI("https://use1-wap.tplinkcloud.com/?token=#{ENV['TP_LINK_TOKEN']}")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Post.new(url)
		request["content-type"] = 'application/json'
		request["cache-control"] = 'no-cache'
		tp_link_id = device == 'jennifer' ? ENV['TP_LINK_JENNIFER'] : ENV['TP_LINK_JOHN']
		request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{tp_link_id}\", \"requestData\": \"{\\\"system\\\":{\\\"get_sysinfo\\\":{}}}\" }}"
		
		response = http.request(request)
		state = !JSON.parse(JSON.parse(response.body)["result"]["responseData"])["system"]["get_sysinfo"]["relay_state"].zero?
	else
		light_number = device == 'jessica' ? 1 : 3
		url = URI("http://192.168.1.165/api/#{ENV['HUE_TOKEN']}/lights/#{light_number}")

		http = Net::HTTP.new(url.host, url.port)

		request = Net::HTTP::Get.new(url)
		request["cache-control"] = 'no-cache'

		response = http.request(request)
		state = JSON.parse(response.body)["state"]["on"]
	end

	return state
  end
end
