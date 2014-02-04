require 'yaml'
require 'dragonfly/dropbox_data_store'
require 'dragonfly/spec/data_store_examples'

config_path = "#{File.dirname(__FILE__)}/config.yml"

if File.exist?(config_path)
  CREDS = YAML.load_file(config_path)
else
  raise 'Please create a config file at spec/config.yml'
end

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    @data_store = Dragonfly::DropboxDataStore.new(
      :app_key             => CREDS['app_key'],
      :app_secret          => CREDS['app_secret'],
      :access_token        => CREDS['access_token'],
      :access_token_secret => CREDS['access_token_secret'],
      :user_id             => CREDS['user_id'],
      :access_type         => CREDS['access_type']
    )
  end
end
