require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "ntpd" do

  it "is installed" do
    expect(package("ntpd")).to be_installed
  end
  
  it "is listening on port 123" do
    expect(port(123)).to be_listening
  end

  it "running" do
    expect(service("ntpd")).to be_running
  end

end