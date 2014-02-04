require 'spec_helper'

describe Dragonfly::DropboxDataStore do

  it_should_behave_like 'data_store'

  let(:app) { Dragonfly.app }
  let(:content) { content1 }
  let(:content1) { Dragonfly::Content.new(app, "pigbot") }
  let(:content2) { Dragonfly::Content.new(app, "pigbot2") }
  let(:new_content) { Dragonfly::Content.new(app) }

  describe "registering with a symbol" do
    it "registers a symbol for configuring" do
      app.configure { datastore :dropbox }
      app.datastore.should be_a(Dragonfly::DropboxDataStore)
    end
  end

  describe "write" do
    it "doesn't overwrite duplicate files" do
      path1 = @data_store.write(content1, path: 'thepath')
      path2 = @data_store.write(content2, path: 'thepath')
      expect(@data_store.read(path1)).to eq content1.data
      expect(@data_store.read(path2)).to eq content2.data
      expect(path1).not_to eq path2
    end

    # yanked wholecloth from: https://github.com/markevans/dragonfly-s3_data_store
    it "should use the name from the content if set" do
      content1.name = 'doobie.doo'
      uid = @data_store.write(content1)
      uid.should =~ /doobie\.doo$/
      new_content.update(*@data_store.read(uid))
      new_content.data.should == 'pigbot'
    end

    it "should work ok with files with funny names" do
      content.name = "A Picture with many spaces in its name (at 20:00 pm).png"
      uid = @data_store.write(content)
      uid.should =~ /A_Picture_with_many_spaces_in_its_name_at_20_00_pm_\.png$/
      new_content.update(*@data_store.read(uid))
      new_content.data.should == 'pigbot'
    end

    it "should allow for setting the path manually" do
      uid = @data_store.write(content, :path => 'hello/there')
      uid.should =~ /hello\/there/
      new_content.update(*@data_store.read(uid))
      new_content.data.should == 'pigbot'
    end
  end
end
