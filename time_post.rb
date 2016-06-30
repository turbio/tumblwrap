require 'tumblr_client'

client = Tumblr.configure do |config|
	config.consumer_key = "Hk2n2K8Iv2W1jEMnMNRxhfzBk8MFV32FjW0hWFT2kG5sAMES3v"
	config.consumer_secret = "jMqyIQo67F4sro1zAmvVpDFdZbwcv4CjcNdPtl6PD0jGeOxn57"
	config.oauth_token = "FwdpZ3TIXlJTWx79IYzaXIPoego1CO4pilUsVNARRT1BGSQmTt"
	config.oauth_token_secret = "FeJCOWEtbvp8yIaW5kUInq2F5wuEGrOLGns6nyjrWBHaegn5xv"
end

client = Tumblr::Client.new
blogname = client.info["user"]["blogs"][0]["name"]

lastpost = nil
while true do
	time = Time.at((Time.now - Time.at(1456727426)).round).utc

	day = "#{time.day} day#{ (time.day == 1) ? '' : 's'}"
	hour = "#{time.hour} hour#{ (time.hour == 1) ? '' : 's'}"
	minute = "#{time.min} minute#{ (time.min == 1) ? '' : 's'}"
	second = "#{time.sec} second#{ (time.sec == 1) ? '' : 's'}"

	fulltime = "#{day}, #{hour}, #{minute}, and #{second}"

	tmp_post = client.text(
		blogname,
		{
			:body => "it's been #{fulltime} and i'm still fucking disabled"
			#:body => "wew"
		})
	puts tmp_post
	if lastpost != nil then
		client.delete(blogname, lastpost["id"]);
	end

	lastpost = tmp_post

	sleep(2)
end
