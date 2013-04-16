require 'json'

class HackDay
  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  
  has n, :projects
end

class Project
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :email, String
  property :creator, String

  has n, :votes
  belongs_to :hack_day

  def as_json(options = {})
    super.merge(votes: { 
      awesome: votes.count(:category => 'awesome'),
      useful: votes.count(:category => 'useful'),
      nocode: votes.count(:category => 'nocode')
    })
  end

end

class Vote
  include DataMapper::Resource

  property :id, Serial
  property :category, String

  belongs_to :project
end


class Leet < Sinatra::Base
  register Sinatra::JstPages

  serve_jst '/javascripts/jst.js'

  configure do
    DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/dev.db")
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  get '/stylesheets/app.css' do
    scss :'stylesheets/app'
  end

  get '/javascripts/app.js' do
    coffee :'javascripts/app'
  end

  get '/' do
    haml :index
  end

  post '/hackdays' do
    HackDay.create(date: Time.now.utc).to_json
  end

  get '/projects' do
    hackday = HackDay.first(:order => [ :date.desc ])
    hackday.projects.to_json
  end

  post '/projects' do
    params = JSON.parse(request.env['rack.input'].read)
    hackday = HackDay.first(:order => [ :date.desc ])
    hackday.projects.create(params['project']).to_json
  end

  post '/votes' do
    params = JSON.parse(request.env['rack.input'].read)
    Vote.create(params).to_json
  end

end
