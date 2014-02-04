require 'dropbox_sdk'
require 'dragonfly'
require "dragonfly/dropbox_data_store/version"

Dragonfly::App.register_datastore(:dropbox) { Dragonfly::DropboxDataStore }

module Dragonfly
  class DropboxDataStore
    attr_accessor :app_key, :app_secret, :access_token, :access_token_secret, 
                  :user_id, :access_type
    
    def initialize(opts = {})
      @app_key             = opts[:app_key]
      @app_secret          = opts[:app_secret]
      @access_token        = opts[:access_token]
      @access_token_secret = opts[:access_token_secret]
      @user_id             = opts[:user_id]
      @access_type         = opts[:access_type] || 'dropbox' # dropbox|app_folder
      # TODO: path for access_type=dropbox
      # TODO: how is path typically specified in dragonfly? leading slash?
      # TODO: meta
    end

    def write(content, opts = {})
      # TODO: deal with dropbox vs. app_folder stuff
      # figure out how paths work for each
      path = opts[:path] || relative_path_for(content.name || 'file')
      storage.put_file(path, content.file)
      path
    end

    def read(path)
      storage.get_file(path)
    rescue DropboxError
      nil
    end

    def destroy(path)
      storage.file_delete(path)
    rescue DropboxError
      nil
    end

    protected

    def storage
      @storage ||= begin
        session = DropboxSession.new(app_key, app_secret)
        session.set_access_token(access_token, access_token_secret)
        DropboxClient.new(session, access_type)
      end
    end

    def relative_path_for(filename)
      time = Time.now
      "#{time.strftime('%Y/%m/%d/')}#{rand(1e15).to_s(36)}_#{filename.gsub(/[^\w.]+/,'_')}"
    end
  end
end
