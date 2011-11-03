require 'spec_helper'

describe ThirtyOne::App do
  include Rack::Test::Methods
  
  let(:app) {
    Rack::Builder.new do
      # use Rack::Lint
      # use Flipper do |f|
      #   f.admin_check do |env|
      #     env['HTTP_COOKIE'].match('admin')
      #   end
      #   f.flag :test_flag, "is a test flag"
      # end
      # use Rack::Lint
      # run Flipper::Admin
    end
    ThirtyOne::App
  }
  
  describe 'on GET /' do
    it 'renders a form' do
      get '/'
      last_response.should be_ok
    end
  end
end