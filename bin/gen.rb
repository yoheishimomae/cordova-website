$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'mustache'
require 'rubygems'
require 'json'

Mustache.template_file = File.dirname(__FILE__) + '/../www/template.html'
view = Mustache.new

json_file = File.dirname(__FILE__) + '/config.json';
data = JSON.parse(IO.read(json_file))


releases = data['releases']
latest_item = releases[0]
len = releases.length;
column_len = (len/3.0).ceil

view[:download_set1] = releases.slice(0, column_len)
view[:download_set2] = releases.slice(column_len, column_len)
view[:download_set3] = releases.slice(column_len*2, column_len)
view[:latest_version] = latest_item['version']
view[:download_link] = latest_item['file']

repos = data['repos']
view[:repo_platforms] = repos['platforms']
view[:repo_platforms][0]['first'] = true
view[:repo_other] = repos['other']
view[:repo_other][0]['first'] = true

sitemap = data['sitemap']
view[:links_general] = sitemap['general']
view[:links_dev] = sitemap['dev']
view[:links_asf] = sitemap['asf']


File.open('www/index.html', 'w') do |file| 
  file.puts view.render(data)
end



