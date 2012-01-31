$LOAD_PATH.unshift File.dirname( __FILE__ ) + '/../lib'
require 'mustache'
require 'rubygems'
require 'json'
require 'ftools'
require 'Fileutils.rb'

# preparation for mustache
Mustache.template_file = File.dirname( __FILE__ ) + '/../www/template.html'
view = Mustache.new
json_file = File.dirname( __FILE__ ) + '/config.json';
data = JSON.parse( IO.read( json_file ) )
releases = data['releases']
latest_item = releases[0]
len = releases.length;
column_len = ( len / 3.0 ).ceil

# download button and archives
view[:download_set1] = releases.slice( 0, column_len )
view[:download_set2] = releases.slice( column_len, column_len )
view[:download_set3] = releases.slice( column_len*2, column_len )
view[:latest_version] = latest_item['version']
view[:download_link] = latest_item['file']

# list of repos
repos = data['repos']
view[:repo_platforms] = repos['platforms']
view[:repo_platforms][0]['first'] = true
view[:repo_other] = repos['other']
view[:repo_other][0]['first'] = true

# quicklinks / sitemap
sitemap = data['sitemap']
view[:links_general] = sitemap['general']
view[:links_dev] = sitemap['dev']
view[:links_asf] = sitemap['asf']

# preparing to generate site
tmp_directory = 'tmp'
Dir.mkdir( tmp_directory ) unless File.exists?( tmp_directory )

# copying files from www
files = Dir.glob( 'www/*' )
FileUtils.cp_r( files, tmp_directory )

# generating index.html
File.open( tmp_directory + '/index.html', 'w' ) do | file | 
    file_data = view.render( data )
    file_data = file_data.gsub( /(\r|\n)<\![\s-]{0,5}localstart[^*]+?localend[\s-]{0,5}>|<!--\spublicstart[^<]+|\spublicend[^*]+?-->/, '' )
    file.puts view.render( file_data )
end

# LessCSS
system( "lessc www/master.less > " + tmp_directory + "/master.css" )

# remove unnecessary files
delete_files = ['/template.html', '/js/local.js', '/js/less-1.1.5.min.js', '/master.less']
for i in delete_files
    File.delete( tmp_directory+i ) unless !File.exists?( tmp_directory+i )
end

# rename tmp folder to public
p_files = Dir.glob( 'public/*' )
FileUtils.rm_rf( p_files ) unless !File.exists?( tmp_directory )
File.rename( tmp_directory, 'public' )

