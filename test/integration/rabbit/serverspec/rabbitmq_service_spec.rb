require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "rabbitmq-server" do

  it "is installed" do
    expect(package("rabbitmq-server")).to be_installed
  end
  
  it "is listening on port 5672" do
    expect(port(5672)).to be_listening
  end

  it "running" do
    expect(service("rabbitmq-server")).to be_running
  end

end

