require 'tumblr_client'
require 'yaml'

class TumblWrap
	@@config_file_path = File.join(__dir__, 'config.yml')
	@@cache_dir = File.join(__dir__, 'cache/')

	def initialize
		@config = YAML::load_file(@@config_file_path)

		Tumblr.configure do |tumblr_conf|
			tumblr_conf.consumer_key = @config['consumer']['key']
			tumblr_conf.consumer_secret = @config['consumer']['secret']
			tumblr_conf.oauth_token = @config['oauth']['token']
			tumblr_conf.oauth_token_secret = @config['oauth']['secret']
		end

		@tumblr_api = Tumblr::Client.new
		@blogs = []
		@posts = []
	end

	def blog(name)
		@blogs.find do |b|
			b.name == name
		end || (@blogs << Blog.new(self, name)).last
	end

	def post(data)
		@posts.find do |p|
			p.id == data['id'] || p.id == data['post_id'].to_i
		end || (@posts << Post.new(self, data)).last
	end

	def api
		puts '...'
		@tumblr_api
	end
end

class Blog
	attr_reader :name

	def initialize(tumblwrap, name)
		@tumblwrap = tumblwrap
		@name = name
		@posts = []
	end

	def name
		@name
	end

	def title
		info['title']
	end

	def description
		info['description']
	end

	def avatar_url
		@saved_avatar || @saved_avatar = @tumblwrap.api.avatar(@name)
	end

	def posts
		return @posts if !@posts.empty?

		loaded_posts = @tumblwrap.api.posts(
			@name,
			:notes_info => true)['posts']

		loaded_posts.each do |p|
			@posts << @tumblwrap.post(p)
		end

		@posts
	end

	private
	def info
		@saved_info || @saved_info = @tumblwrap.api.blog_info(@name)['blog']
	end
end

class Post
	attr_reader :id, :blog, :url, :type, :tags, :parent, :title, :body

	def initialize(tumblwrap, data)
		@tumblwrap = tumblwrap

		@blog = @tumblwrap.blog(data['blog_name'])

		@id = data['id'] || data['post_id'].to_i
		@url = data['url']
		@type = data['type']
		@tags = data['tags']
		@title = data['title']
		@body = data['body']
		@parent =
			@tumblwrap.blog(data['reblog_parent_blog_name']) if !data['reblog_parent_blog_name'].nil?

		data['notes'].each do |note|
			if note['type'] == 'reblog'
				@tumblwrap.post note
				if note['post_id'].to_i == @id && !note['reblog_parent_blog_name'].nil?
					@parent = @tumblwrap.blog(note['reblog_parent_blog_name'])
				end
			end
		end if !data['notes'].nil?
	end
end

#if File.exists?(cache_file_name)
	#puts "using cache file #{cache_file_name}"
	#cache_file = File.open(cache_file_name, "r")

	#posts = YAML.load cache_file.read
#else
	#puts "creating cache file #{cache_file_name}"

	#cache_file = File.open(cache_file_name, "w")
	#total_posts = client.blog_info(blogname)["blog"]["posts"].to_i

	#while posts.length < total_posts
		#puts "downloading #{posts.length}/#{total_posts} #{((posts.length.to_f / total_posts.to_f) * 100.to_f).round}%";
		#batch = client.posts(
			#blogname,
			#:offset => posts.length,
			#:reblog_info => true,
			#:note_info => true,
			#:limit => 1000)['posts']
		#posts += batch
	#end

	#cache_file.puts posts.to_yaml
	#cache_file.close

#end
