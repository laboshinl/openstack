require 'serverspec'

set :backend, :exec

describe "ntpd" do

  it "is installed" do
    expect(package("ntp")).to be_installed
  end
  
  it "is enabled" do
    expect(service("ntpd")).to be_enabled
  end
  
  it "is running" do
    expect(service("ntpd")).to be_running
  end
  
  it "is listening on port 123" do
    expect(port(123)).to be_listening
  end

end