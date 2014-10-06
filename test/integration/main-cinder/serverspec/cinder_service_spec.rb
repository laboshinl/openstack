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

describe "openstack-cinder-volume" do
  it "is installed" do
    expect(package("openstack-cinder")).to be_installed
  end
  it "is enabled" do
    expect(service("openstack-cinder-volume")).to be_enabled
  end
  it "is running" do
    expect(service("openstack-cinder-volume")).to be_running
  end
#  it "is listening on port 9292" do
#    expect(port(9292)).to be_listening
#  end
end

describe "openstack-cinder-api" do
  it "is installed" do
    expect(package("openstack-cinder")).to be_installed
  end
  it "is enabled" do
    expect(service("openstack-cinder-api")).to be_enabled
  end
  it "is running" do
    expect(service("openstack-cinder-api")).to be_running
  end
  it "is listening on port 8776" do
    expect(port(8776)).to be_listening
  end
end

describe "openstack-cinder-scheduler" do
  it "is installed" do
    expect(package("openstack-cinder")).to be_installed
  end
  it "is enabled" do
    expect(service("openstack-cinder-scheduler")).to be_enabled
  end
  it "is running" do
    expect(service("openstack-cinder-scheduler")).to be_running
  end
#  it "is listening on port 9191" do
#    expect(port(9191)).to be_listening
#  end
end

describe " targetcli" do
  it "is installed" do
    expect(package(" targetcli")).to be_installed
  end
  it "is enabled" do
    expect(service("target")).to be_enabled
  end
  it "is running" do
    expect(service("target")).to be_running
  end
 # it "is listening on port 9191" do
 #   expect(port(9191)).to be_listening
 # end
end