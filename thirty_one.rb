require 'sinatra/base'
require 'sprockets'
require 'active_record'
require 'active_support'

module ThirtyOne

  def self.sprockets_environment
    @sprockets ||= begin
      Sprockets::Environment.new.tap do |e|
        e.append_path 'assets/javascripts'
        e.append_path 'assets/stylesheets'
        e.append_path 'assets/images'
        e.append_path 'vendor/assets/javascripts'
        e.append_path 'vendor/assets/stylesheets'
      end
    end
  end

  class Bit
    def self.all
      require 'yaml'
      @bits = YAML.load(ERB.new(File.read("bits.yml")).result(binding))
    end
  end
  
  class Model < ::ActiveRecord::Base
    self.abstract_class = true
  end
  
  class Party < Model
    has_many :party_bits
    
    def bits
      @bits ||= get_bits!
    end
    
    def get_bits!
      @bits = nil
      party_bits.reload
      party_bits.map(&:bit_path)
    end
    
    def bits=(bit_list)
      @bits = bit_list
    end
    
    # Need to save bits after save
    after_save :update_bits
    def update_bits
      transaction do
        party_bits.clear
        bits.each do |bit|
          party_bits.create(:bit_path => bit)
        end
      end
    end
  end
  
  class PartyBit < Model
    belongs_to :party
  end

  class App < ::Sinatra::Base
    helpers do
      def datetime_key_path(date, hour=nil)
        "".tap do |output|
          output << "datetime_#{date.strftime('%m%d')}"
          output << ".#{hour}p" if hour
        end
      end
      
      def time_range(hour)
        "#{hour}#{hour+2 < 12 ? '' : 'pm'}&ndash;#{hour+2}#{hour+2 < 12 ? 'pm' : 'am'}"
      end

      def asset_path(path)
        asset = ThirtyOne.sprockets_environment[path]
        "/assets/" + asset.digest_path
      end

      def bit_to_string(namespace, value)
        "#{namespace.to_s}.#{value.to_s}"
      end
    end
    
    before do
      @days = (Date.parse("2011-12-01")..Date.parse("2011-12-05"))
      @bits = Bit.all
    end

    get '/data' do
      "<pre>#{@bits.inspect}</pre>"
    end
    
    post '/parties' do      
      @party = Party.new params[:party]
      if @party.save
        redirect to("/parties/#{@party.id}")
      else
        erb :index
      end
    end
    
    post '/parties/:id' do |id|
      @party = Party.find(id)
      if @party.update_attributes(params[:party])
        redirect to("/parties/#{@party.id}")
      else
        erb :index
      end
    end
    
    get '/parties/:id' do |id|
      @party = Party.find(id)
      erb :index
    end

    get '/' do
      params['party'] ||= {}
      params['party']['email'] ||= params['email']
      @party = Party.new(params['party'])
      erb :index
    end

  end
end