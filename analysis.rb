require_relative 'tumblwrap'

blogname = ARGV[0]

if blogname.nil?
	puts 'you must specify a blog name'
	exit 1
end

tumblr = TumblWrap.new

#blog = tumblr.blog blogname

#puts blog.name
#puts blog.title
#puts blog.description
#puts blog.avatar_url

blog = tumblr.blog blogname

puts blog.name
puts blog.title
puts blog.description

blog.posts.each do |post|
	puts "id: #{post.id}"
	puts "title: #{post.title}"
	puts "body: #{post.body}"
	puts "type: #{post.type}"
	puts "from: #{post.parent && post.parent.name}"
	puts
end

#blog_stack_top = {name: blogname, refs: Array.new, count: 1}
#current_location = blog_stack_top

#posts.each do |post|
	#trail = post['trail']
	#next if trail.nil?

	#referenced_blog = if trail.length == 0
						#referenced_blog = current_location[:name]
					#else
						#trail[0]['blog']['name']
					#end

	#unless current_location[:refs].any?  { |item|
			#if item[:name] == referenced_blog then item[:count] += 1 end }

		#current_location[:refs].push({
			#name: referenced_blog,
			#refs: Array.new,
			#count: 1
		#})
	#end
#end

#blog_stack_top[:refs].sort! { |a,b| b[:count] <=> a[:count] }

#counts = Hash.new(0)
#blog_stack_top[:refs].each { |ref|
	#counts[ref[:count]] += 1
#}

#puts counts
#puts counts.length

#ap blog_stack_top

#ap posts[0]

#graph = GraphViz.new(:G, :type => :digraph)
#graph.node[:penwidth] = 1
#graph.node[:shape] = "rectangle"
#graph[:rankdir] = "LR"
##graph[:nodesep] = ".01"

#current_blog_node = graph.add_nodes(blog_stack_top[:name])

#blog_stack_top[:refs].each do |ref|
	#graph.edge[:label] = ref[:count]
	#graph.add_edges(graph.add_nodes(ref[:name]), current_blog_node)
#end



#posts.each do |post|
	#trail = post['trail']
	#linked_blog = current_blog;

	#if trail != nil and trail.length > 0
	#end
#end

#graph.output(:svg => "/srv/http/pisscake.com/maka.svg")
#graph.output(:png => "/srv/http/pisscake.com/maka.png")
