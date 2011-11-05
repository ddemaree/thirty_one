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
      @bits = YAML.load(ERB.new(File.read("#{APP_ROOT}/db/bits.yml")).result(binding))
    end
  end
  
  class RandomPhrase
    def self.entropy
      97 * (ADJECTIVES.length * NOUNS.length)
    end
    
    ADJECTIVES = [
      "cute", "dapper", "large", "small", "long", "short", "thick", "narrow",
      "deep", "flat", "whole", "low", "high", "near", "far", "fast",
      "quick", "slow", "early", "late", "bright", "dark", "cloudy", "warm",
      "cool", "cold", "windy", "noisy", "loud", "quiet", "dry", "clear",
      "hard", "soft", "heavy", "light", "strong", "weak", "tidy", "clean",
      "dirty", "empty", "full", "close", "thirsty", "hungry", "fat", "old",
      "fresh", "dead", "healthy", "sweet", "sour", "bitter", "salty", "good",
      "bad", "great", "important", "useful", "expensive", "cheap", "free", "difficult",
      "strong", "weak", "able", "free", "rich", "afraid", "brave", "fine",
      "sad", "proud", "comfortable", "happy", "clever", "interesting", "famous", "exciting",
      "funny", "kind", "polite", "fair", "share", "busy", "free", "lazy",
      "lucky", "careful", "safe", "dangerous", "quirky", "spunky", "fresh"
    ]

    # English plural nouns (all animals)
    NOUNS = [
      "rabbits", "badgers", "foxes", "chickens", "bats", "deer", "snakes", "hares",
      "hedgehogs", "platypuses", "moles", "mice", "otters", "rats", "squirrels", "stoats",
      "weasels", "crows", "doves", "ducks", "geese", "hawks", "herons", "kingfishers",
      "owls", "peafowl", "pheasants", "pigeons", "robins", "rooks", "sparrows", "starlings",
      "swans", "ants", "bees", "butterflies", "dragonflies", "flies", "moths", "spiders",
      "pikes", "salmons", "trouts", "frogs", "newts", "toads", "crabs", "lobsters",
      "clams", "cockles", "mussels", "oysters", "snails", "cattle", "dogs", "donkeys",
      "goats", "horses", "pigs", "sheep", "ferrets", "gerbils", "guinea pigs", "parrots",
      "monkeys", "gorillas", "eagles", "lions", "leopards", "tigers", "panthers", "jaguars",
      "bears"
    ]
    
    VERBS = [
      "sang", "played", "knitted", "floundered", "danced", "played", "listened", "ran",
      "talked", "cuddled", "sat", "kissed", "hugged", "whimpered", "hid", "fought",
      "whispered", "cried", "snuggled", "walked", "drove", "loitered", "whimpered", "felt",
      "jumped", "hopped", "went", "married", "engaged" 
    ]

    ADVERBS = [
      "jovially", "merrily", "cordially", "easily"
    ]
    
    def self.generate
      [].tap do |arr|
        arr << (rand(97)+2).to_s
        %w(adjectives nouns).each do |coll|
          arr << get_random_value(coll)
        end
      end.join("-")
    end
    
    def self.get_random_value(collection)
      const = "#{self}::#{collection.to_s.upcase}".constantize
      const[rand(const.length)]
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
    
    def to_param
      unique_phrase || id
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
    
    before_create :generate_unique_phrase
    def generate_unique_phrase
      self.unique_phrase ||= ThirtyOne::RandomPhrase.generate
    end
    
  end
  
  class PartyBit < Model
    belongs_to :party
  end

  class App < ::Sinatra::Base
    enable :sessions
    
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
        redirect to("/thanks/#{@party.unique_phrase}")
      else
        erb :index
      end
    end
    
    post '/party/:id' do |id|
      @party = Party.find_by_unique_phrase(id) || Party.find(id)
      if @party.update_attributes(params[:party])
        session[:secret_party_id] = @party.unique_phrase
        redirect to("/party/#{@party.unique_phrase}")
      else
        erb :index
      end
    end
    
    get '/party/:id' do |id|
      @party = Party.find_by_unique_phrase(id) || Party.find(id)
      session[:secret_party_id] = @party.unique_phrase
      erb :index
    end
    
    get '/thanks/:party_id' do |party_id|
      @party = Party.find_by_unique_phrase!(party_id)
      session[:secret_party_id] = @party.unique_phrase
      erb :thanks
    end

    get '/new_party' do
      params['party'] ||= {}
      params['party']['email'] ||= params['email']
      @party = Party.new(params['party'])
      erb :index
    end

    get '/' do
      if session[:secret_party_id]
        redirect to("/party/#{session[:secret_party_id]}")
      else
        redirect to("/new_party")
      end
    end

  end
end