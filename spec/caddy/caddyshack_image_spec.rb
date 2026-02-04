require 'docker'
require 'serverspec'
require 'spec_helper'

describe "Caddy is installed" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :backend, :docker
    set :docker_image, image.id
  end

  describe command('caddy --version') do
    its(:stdout) { should match "v2.10.2 h1:g/gTYjGMD0dec+UgMw8SnfmJ3I9+M2TdvoRL/Ovu6U8=\n"}
  end

  describe "Caddyfile is present" do
    describe file('/etc/caddy/Caddyfile') do
      it { should exist }
      it { should be_file }
      its(:content) { should match(/:80/) }
    end
  end

  describe "Caddy config is valid" do
    describe command('caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/valid configuration|success|OK/i) }
    end
  end
end

describe "Caddy image runtime behavior" do
  before(:all) do
    @host_port = 8080

    image = Docker::Image.build_from_dir('.')

    @container = Docker::Container.create(
      'Image' => image.id,
      'ExposedPorts' => { '80/tcp' => {} },
      'HostConfig' => {
        'PortBindings' => {
          '80/tcp' => [{ 'HostPort' => @host_port.to_s }]
        }
      }
    )

    @container.start

    # Wait until Caddy is ready (prevents flaky tests)
    30.times do
      break if system("curl -fsS http://localhost:#{@host_port} >/dev/null 2>&1")
      sleep 0.2
    end
  end

  after(:all) do
    @container&.delete(force: true)
  end

  it "returns ok on HTTP request" do
    set :backend, :exec

    response = command("curl -fsS http://localhost:#{@host_port}").stdout
    expect(response).to eq("ok")
  end
end