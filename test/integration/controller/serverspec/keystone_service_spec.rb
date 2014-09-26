require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "openstack-keystone" do

  it "is listening on port 5000" do
    expect(port(5000)).to be_listening
  end
 
  it "is listening on port 35357" do
    expect(port(35357)).to be_listening
  end

  it "has a running service" do
    expect(service("openstack-keystone")).to be_running
  end

end
