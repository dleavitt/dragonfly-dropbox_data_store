require 'dragonfly'
require 'dropbox_sdk'
require 'dragonfly/dropbox_data_store/version'
require 'dragonfly/dropbox_data_store/railtie' if defined?(Rails)

Dragonfly::App.register_datastore(:dropbox) { Dragonfly::DropboxDataStore }

module Dragonfly
  class DropboxDataStore
    attr_accessor :app_key, :app_secret, :access_token, :access_token_secret, 
                  :user_id, :access_type, :store_meta, :root_path
    
    def initialize(opts = {})
      @app_key             = opts[:app_key]
      @app_secret          = opts[:app_secret]
      @access_token        = opts[:access_token]
      @access_token_secret = opts[:access_token_secret]
      @user_id             = opts[:user_id]
      @access_type         = opts[:access_type] || 'app_folder' # dropbox|app_folder

      @store_meta          = opts[:store_meta]
      # TODO: this should default to 'dragonfly' for dropbox access type
      @root_path           = opts[:root_path] || ''

      # TODO: path for access_type=dropbox
      # TODO: how is path typically specified in dragonfly? leading slash?
    end

    def write(content, opts = {})
      # TODO: deal with dropbox vs. app_folder stuff
      # figure out how paths work for each
      path = opts[:path] || absolute(relative_path_for(content.name || 'file'))
      data_path = storage.put_file(path, content.file)['path']
      storage.put_file(meta_path(data_path), YAML.dump(content.meta)) if store_meta?
      relative(data_path)
    end

    def read(path)
      path = absolute(path)
      # TODO: possibly return some of dropbox's native metadata automatically
      wrap_error do
        [ storage.get_file(path),
          store_meta? && YAML.load(storage.get_file(meta_path(path))) ]
      end
    end

    def destroy(path)
      path = absolute(path)
      # TODO: purge empty directories
      wrap_error { storage.file_delete(meta_path(path)) } if store_meta?
      wrap_error { storage.file_delete(path) }
    end

    # Only option is "expires" and it's a boolean
    def url_for(path, opts = {})
      path = absolute(path)
      (opts[:expires] ? storage.media(path) : storage.shares(path))['url']
    end

    # TODO: thumbnail data-uri

    def store_meta?
      @store_meta != false # Default to true if not set
    end

    def storage
      @storage ||= begin
        session = DropboxSession.new(app_key, app_secret)
        session.set_access_token(access_token, access_token_secret)
        DropboxClient.new(session, access_type)
      end
    end

    protected

    def wrap_error
      yield
    rescue DropboxError
      nil
    end

    def absolute(relative_path)
      relative_path.to_s == '.' ? root_path : File.join(root_path, relative_path)
    end

    def relative(absolute_path)
      absolute_path[/^\/?#{Regexp.escape root_path}\/?(.*)$/, 1]
    end

    def meta_path(data_path)
      "#{data_path}.meta.yml"
    end

    # TODO: make this overrideable via param
    def relative_path_for(filename)
      time = Time.now
      "#{time.strftime('%Y/%m/%d/')}#{rand(1e15).to_s(36)}_#{filename.gsub(/[^\w.]+/,'_')}"
    end
  end
end
