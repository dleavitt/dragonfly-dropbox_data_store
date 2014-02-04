require 'spec_helper'

describe Dragonfly::DropboxDataStore do

  it_should_behave_like 'data_store'

  let (:app) { Dragonfly.app }
  let (:content) { Dragonfly::Content.new(app, "pigbot") }
  let (:new_content) { Dragonfly::Content.new(app) }

  describe "registering with a symbol" do
    it "registers a symbol for configuring" do
      app.configure { datastore :dropbox }
      app.datastore.should be_a(Dragonfly::DropboxDataStore)
    end
  end
end
