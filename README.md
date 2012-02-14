Cordova Website
==========================


Libraries it uses
-----------------------

- Mustache for Ruby
- LessCSS
- Json


How to compile the site
-----------------------

- from commandline, set `cd` to your `cordova-website` repo
- run the command: `ruby bin/gen.rb`
- the site will be generated in `public` folder


Things you should know
-----------------------

- `bin/config.json` + `www/template.html` + Mustache outputs `index.html`
- `bin/config.json` contains information for: download & archives, quick links, and list of repos
- the site can be tested by running `www` locally. This is handy for modifying css
