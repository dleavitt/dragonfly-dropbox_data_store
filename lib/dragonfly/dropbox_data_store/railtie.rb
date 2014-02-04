module Dragonfly
  class DropboxDataStore
    class Railtie < Rails::Railtie
      rake_tasks do
        load "dragonfly/dropbox_data_store/tasks.rake"
      end
    end
  end
end
