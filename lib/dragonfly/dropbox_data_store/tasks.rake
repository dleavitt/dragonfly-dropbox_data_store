# Ganked verbatim from: https://github.com/janko-m/paperclip-dropbox

require "dragonfly/dropbox_data_store/rake"

namespace :dropbox do
  desc "Obtains your Dropbox credentials"
  task :authorize do
    if ENV["APP_KEY"].nil? or ENV["APP_SECRET"].nil?
      puts "USAGE: `rake dropbox:authorize APP_KEY=your_app_key APP_SECRET=your_app_secret` ACCESS_TYPE=your_access_type"
      exit
    end

    Dragonfly::DropboxDataStore::Rake.authorize(ENV["APP_KEY"], ENV["APP_SECRET"], ENV["ACCESS_TYPE"] || "dropbox")
  end
end
