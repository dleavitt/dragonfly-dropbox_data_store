# Dragonfly::DropboxDataStore

[Dropbox](https://www.dropbox.com/developers) data store for [Dragonfly](https://github.com/markevans/dragonfly) uploads.

Ganked from [here](https://github.com/markevans/dragonfly-s3_data_store) and [here](https://github.com/robin850/carrierwave-dropbox) and then sort of mashed together.

## Installation

### Gem

Add this line to your application's Gemfile:

    gem 'dragonfly-dropbox_data_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dragonfly-dropbox_data_store

### Dropbox app setup

Go here and create a new app: https://www.dropbox.com/developers/apps

Select "Dropbox API App" and then "Datastores only."

The latter option means the app can only access files within its application sandbox rather than your whole Dropbox. This sandbox is located in `Apps/{your-app-name}` within your Dropbox.

Once you've created your app, you can use the supplied rake task to generate the rest of your credentials.

    $ rake dropbox:authorize APP_KEY=your_app_key APP_SECRET=your_app_secret

If you're using Rails it should just work. Otherwise you'll have to add something like this to your Rakefile:

```ruby
# Rakefile
load "dragonfly/dropbox_data_store/tasks.rake"
```

Hold on to these creds for the next step.

## Useage

### Configuration

In your Dragonfly config file:

```ruby
require 'dragonfly/dropbox_data_store'

Dragonfly.app.configure do
  # ...

  datastore :dropbox,
  app_key:              ENV['DROPBOX_APP_KEY'],
  app_secret:           ENV['DROPBOX_APP_SECRET'],
  access_token:         ENV['DROPBOX_ACCESS_TOKEN'],
  access_token_secret:  ENV['DROPBOX_ACCESS_TOKEN_SECRET'],
  user_id:              ENV['DROPBOX_USER_ID'],     
  root_path:            Rails.env # optional

  # ...
end
```

### All config options

```ruby
:app_key             
:app_secret             
:access_token        
:access_token_secret    
:user_id             
:access_type         # only app_folder for now.
:store_meta          # whether to store file metadata. default: true
:root_path           # where inside your app dir to put this stuff. default: '/'
```

### Per-storage options

You can set the path for the uploaded file:

```ruby
Dragonfly.app.store(some_file, path: 'some/path.txt')
```

This is _not_ relative to your `root_path`. Dropbox will automatically name files so as to avoid conflicts.

### Dropbox Image URLs

You can get direct Dropbox links to your uploads like so:

```ruby
Dragonfly.app.remote_url_for('some/uid')
```

or

```ruby
my_model.attachment.remote_url
```

By default these return a "share" URL - a nice shortened permalink to the item in question. If you want expiring links, you can generate them like this:

```ruby
my_model.attachment.remote_url(expires: true)
```

They'll expire in about four hours.

## Contributing

Fork & PR.

## To Do

- Get it to work with "dropbox-style" (full permissions) apps. Maybe.
- Wipe out empty directories.
- Make the path generation method customizable.
- See if we can do something useful with Dropbox's metadata.

### Testing

Check the setup instructions to get your creds. Then make a config file:
  
    $ cp spec/config.sample.yml spec/config.yml

Fill the new config file in with your creds. The tests only run against the live Dropbox API for now, so you'll need real creds, and you'll want to make sure there's nothing in your app's `/dragonfly_test` dir (it gets wiped out every run.)
