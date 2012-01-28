$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'mustache'
require 'yaml'

Mustache.template_file = File.dirname(__FILE__) + '/../www/template.html'
view = Mustache.new

yml_file = File.dirname(__FILE__) + '/download.yml';

readme = YAML::load( File.open( yml_file) )

items = readme['items']
len = items.length;
clen = (len/3.0).ceil

view[:download_set1] = items.slice(0, clen)
view[:download_set2] = items.slice(clen, clen)
view[:download_set3] = items.slice(clen*2, clen)

File.open('www/index.html', 'w') do |file| 
  file.puts view.render(readme)
end

# view.render(readme)