require 'uri'
require 'net/http'

class DashboardController < ApplicationController
	@@jennifer = @@john = @@jessica = @@james = true
	@@current_temp
	before_action :authenticate_user!

  def kitchen_sink
    render :kitchen_sink, layout: "kitchen"
  end
  def kitchen8_sink
    render :kitchen8_sink, layout: "kitchen8"
  end

  def index
  	render
  end

  def jennifer
  	if request.get?
  		@@jennifer = get_current_state('jennifer')
  		@jennifer = @@jennifer
	 	render partial: "shared/jennifer"
	elsif request.post?
	 	@@jennifer = get_current_state('jennifer')
	 	next_state = @@jennifer ? 0 : 1
	 	url = URI("https://use1-wap.tplinkcloud.com/?token=#{ENV['TP_LINK_TOKEN']}")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Post.new(url)
		request["content-type"] = 'application/json'
		request["cache-control"] = 'no-cache'
	 	request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{ENV['TP_LINK_JENNIFER']}\", \"requestData\": \"{\\\"system\\\":{\\\"set_relay_state\\\":{\\\"state\\\":#{next_state}}}}\" }}"
  		http.request(request)

	 	render :js => "$('#jennifer-button').load('/jennifer');"
	end
  end

  def john
  	if request.get?
  		@@john = get_current_state('john')
  		@john = @@john
	 	render partial: "shared/john"
	elsif request.post?
	 	@@john = get_current_state('john')
	 	next_state = @@john ? 0 : 1
	 	url = URI("https://use1-wap.tplinkcloud.com/?token=#{ENV['TP_LINK_TOKEN']}")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Post.new(url)
		request["content-type"] = 'application/json'
		request["cache-control"] = 'no-cache'
	 	request.body = "{\"method\":\"passthrough\", \"params\": {\"deviceId\": \"#{ENV['TP_LINK_JOHN']}\", \"requestData\": \"{\\\"system\\\":{\\\"set_relay_state\\\":{\\\"state\\\":#{next_state}}}}\" }}"
  		http.request(request)

	 	render :js => "$('#john-button').load('/john');"
	end
  end

  def james
  	if request.get?
  		@@james = get_current_state('james')
  		@james = @@james
	 	render partial: "shared/james"
	elsif request.post?
	 	@@james = get_current_state('james')
	 	next_state = !@@james

	 	url = URI("http://#{ENV['HOME_IP']}:#{ENV['HOME_PORT']}/james")

		http = Net::HTTP.new(url.host, url.port)

		request = Net::HTTP::Put.new(url)
		request["content-type"] = 'application/json'
		request.body = "{\"state\": #{next_state}}"

		response = http.request(request)

	 	render :js => "$('#james-button').load('/james');"
	end
  end

  def jessica
  	if request.get?
  		@@jessica = get_current_state('jessica')
  		@jessica = @@jessica
	 	render partial: "shared/jessica"
	elsif request.post?
	 	@@jessica = get_current_state('jessica')
	 	next_state = !@@jessica

	 	url = URI("http://#{ENV['HOME_IP']}:#{ENV['HOME_PORT']}/jessica")

		http = Net::HTTP.new(url.host, url.port)

		request = Net::HTTP::Put.new(url)
		request["content-type"] = 'application/json'
		request.body = "{\"state\": #{next_state}}"

		response = http.request(request)

	 	render :js => "$('#jessica-button').load('/jessica');"
	end
  end

  def nest
  	@@current_temp = get_current_temperature 
  	@current_temp = @@current_temp
  	render partial: "shared/nest"
  end

  def nest_temp_up
  	current_temp = get_current_temperature
  	target_temp = current_temp + 0.5
  	set_target_temperature(target_temp)
  	@@current_temp = target_temp
  	render :js => "$('#nest').load('/nest');"
  end

  def nest_temp_down
  	current_temp = get_current_temperature
  	target_temp = current_temp - 0.5
  	set_target_temperature(target_temp)
  	@@current_temp = target_temp
  	render :js => "$('#nest').load('/nest');"
  end

  def tv_volume_up
  	url = URI("https://192.168.1.164:9000/key_command/")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Put.new(url)
	request["content-type"] = 'application/json'
	request["auth"] = '123A456B'
	request.body = "{\"KEYLIST\": [{\"CODESET\": 5,\"CODE\": 1,\"ACTION\":\"KEYPRESS\"}]}"

	response = http.request(request)
  end

  def tv_volume_down
  	url = URI("https://192.168.1.164:9000/key_command/")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Put.new(url)
	request["content-type"] = 'application/json'
	request["auth"] = '123A456B'
	request.body = "{\"KEYLIST\": [{\"CODESET\": 5,\"CODE\": 0,\"ACTION\":\"KEYPRESS\"}]}"

	response = http.request(request)
  end

  def tv
  	url = URI("http://#{ENV['HOME_IP']}:#{ENV['HOME_PORT']}/power")
  	http = Net::HTTP.new(url.host, url.port)
  	request = Net::HTTP::Get.new(url)
  	response = http.request(request)
  end

  def sign_out
  end

  private
  def get_current_temperature
	url = URI("https://developer-api.nest.com/devices/thermostats/#{ENV['NEST_THERMOSTAT_ID']}")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(url)
	request["content-type"] = 'application/json'
	request["authorization"] = "Bearer #{ENV['NEST_TOKEN']}"

	response = http.request(request)

	redirect_url = URI(response['location'])

	http = Net::HTTP.new(redirect_url.host, redirect_url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(redirect_url)
	request["content-type"] = 'application/json'
	request["authorization"] = "Bearer #{ENV['NEST_TOKEN']}"

	response = http.request(request)

	return JSON.parse(response.body)['target_temperature_c']
  end

  def set_target_temperature(target)
  	url = URI("https://developer-api.nest.com/devices/thermostats/#{ENV['NEST_THERMOSTAT_ID']}")

  	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Put.new(url)
	request["content-type"] = 'application/json'
	request["authorization"] = "Bearer #{ENV['NEST_TOKEN']}"
	request.body = "{\"target_temperature_c\": #{target}}"	
	response = http.request(request)
	redirect_url = URI(response['location'])

	http = Net::HTTP.new(redirect_url.host, redirect_url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Put.new(url)
	request["content-type"] = 'application/json'
	request["authorization"] = "Bearer #{ENV['NEST_TOKEN']}"
	request.body = "{\"target_temperature_c\": #{target}}"

	response = http.request(request)
  end

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
		url = URI("http://#{ENV['HOME_IP']}:#{ENV['HOME_PORT']}/#{device}")

		http = Net::HTTP.new(url.host, url.port)
		request = Net::HTTP::Get.new(url)

		response = http.request(request)
		state = JSON.parse(response.body)['state']
	end

	return state
  end
end
