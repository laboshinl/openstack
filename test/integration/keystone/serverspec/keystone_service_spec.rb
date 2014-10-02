require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "mariadb" do
  it "is installed" do
    expect(package("mariadb-galera-server")).to be_installed
  end
  it "is enabled" do
    expect(service("mariadb")).to be_enabled
  end
  it "is running" do
    expect(service("mariadb")).to be_running
  end
  it "is listening on port 3306" do
    expect(port(3306)).to be_listening
  end
end

describe "openstack-keystone" do
  it "is installed" do
    expect(package("openstack-keystone")).to be_installed
  end
  it "is enabled" do
    expect(service("openstack-keystone")).to be_enabled
  end
  it "is running" do
    expect(service("openstack-keystone")).to be_running
  end
  it "is listening on port 5000" do
    expect(port(5000)).to be_listening
  end
  it "is listening on port 35357" do
    expect(port(35357)).to be_listening
  end

end
