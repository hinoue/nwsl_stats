require 'json'
require 'time'
require 'elo_rating'

FILENAME=ARGV[0]
#FILENAME='./nwsl-2018.json'
INITIAL_ELO=1500
K_FACTOR=24

data = File.new(FILENAME, 'r').read()
matches= JSON.parse(data)

teams = {}

EloRating::k_factor = K_FACTOR

#matches.each do |match|
#    puts match['home_team']
#    puts match['away_team']
#    puts match['match_date']
#end

matches.sort! { |x,y| DateTime.strptime(x['match_date'], format='%Y-%m-%d') <=>
                      DateTime.strptime(y['match_date'], format='%Y-%m-%d') }

matches.each do |match|
    home_team = match['home_team']['home_team_name']
    away_team = match['away_team']['away_team_name']

    teams[home_team] = INITIAL_ELO if not teams.key?(home_team)
    teams[away_team] = INITIAL_ELO if not teams.key?(away_team)

    result = EloRating::Match.new
    if match['home_score'] == match['away_score']
        result.add_player(rating: teams[home_team])
        result.add_player(rating: teams[away_team])
    elsif match['home_score'] > match['away_score']
        result.add_player(rating: teams[home_team], winner: true)
        result.add_player(rating: teams[away_team])
    elsif match['home_score'] < match['away_score']
        result.add_player(rating: teams[home_team])
        result.add_player(rating: teams[away_team], winner: true)
    end
    updated_ratings = result.updated_ratings
    teams[home_team] = updated_ratings[0]
    teams[away_team] = updated_ratings[1]
end

teams.to_a.sort { |x,y| y[1] <=> x[1] }.each do |val|
    team = val[0] 
    elo  = val[1]
    puts "#{elo} \"#{team}\""
end

