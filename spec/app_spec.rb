require 'spec_helper'

describe ThirtyOne::App do
  include Rack::Test::Methods

  let(:app) { ThirtyOne::App }

  describe 'on GET /' do
    it 'renders the form' do
      get '/'
      last_response.should be_ok
    end
  end

  describe 'on POST /parties' do
    it "creates a new party"

    context "with invalid parameters" do
      it "displays an error message"
    end
  end

  describe "GET /party/:id" do
    it 'renders the form'
  end

  describe "POST /party/:id" do
    it 'saves chanes to the party'
  end
end