require 'serverspec'

set :backend, :exec

describe "rabbitmq-server" do

  it "is installed" do
    expect(package("rabbitmq-server")).to be_installed
  end
  
  it "is enabled" do
    expect(service("rabbitmq-server")).to be_enabled
  end
  
  it "is running" do
    expect(service("rabbitmq-server")).to be_running
  end
  
  it "is listening on port 5672" do
    expect(port(5672)).to be_listening
  end

end

