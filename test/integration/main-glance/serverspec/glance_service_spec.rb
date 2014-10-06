require 'serverspec'

set :backend, :exec

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

describe "openstack-glance-api" do
  it "is installed" do
    expect(package("openstack-glance")).to be_installed
  end
  it "is enabled" do
    expect(service("openstack-glance-api")).to be_enabled
  end
  it "is running" do
    expect(service("openstack-glance-api")).to be_running
  end
  it "is listening on port 9292" do
    expect(port(9292)).to be_listening
  end
end

describe "openstack-glance-registry" do
  it "is installed" do
    expect(package("openstack-glance")).to be_installed
  end
  it "is enabled" do
    expect(service("openstack-glance-registry")).to be_enabled
  end
  it "is running" do
    expect(service("openstack-glance-registry")).to be_running
  end
  it "is listening on port 9191" do
    expect(port(9191)).to be_listening
  end
end