require 'sinatra'
require 'pry'

#This method simply lists the teams in an array
def teams_array(records)
  teams = []
  records.each do |gamehash|
    if !teams.include?(gamehash[:home_team])
      teams << gamehash[:home_team]
    end
    if !teams.include?(gamehash[:away_team])
      teams << gamehash[:away_team]
    end
  end
teams
end

#Data
nfl_records =
[
  {home_team: "Patriots", away_team: "Broncos", home_score: 7, away_score: 3},
  {home_team: "Broncos", away_team: "Colts", home_score: 3, away_score: 0},
  {home_team: "Patriots", away_team: "Colts", home_score: 11, away_score: 7},
  {home_team: "Steelers", away_team: "Patriots", home_score: 7, away_score: 21}
]

get '/' do
  teams = []
  teams_array(nfl_records).each do |team|
    teams << team
  end
  @teams = teams
  erb :index
end


#This method sets up my data structure with zero values.
def blank_record_hash(array_of_teams)
  z = Hash.new
  array_of_teams.each do |team|
      z[team] = {"W" => 0, "L" => 0}
  end
  z
end

#This method is an intermediate step to counting wins. It collects instances of a team name equal to number of wins.
def array_of_winners(records)
  winner = []
  records.each do |gamehash|
    if gamehash[:home_score] > gamehash[:away_score]
      winner << gamehash[:home_team].to_s
    else
      winner << gamehash[:away_team].to_s
    end
  end
  winner
end

#This method is an intermediate step to counting losses. It collects instances of a team name eaqual to number of losses.
def array_of_losers(records)
  loser = []
  records.each do |gamehash|
    if gamehash[:home_score] < gamehash[:away_score]
      loser << gamehash[:home_team].to_s
    else
      loser << gamehash[:away_team].to_s
    end
  end
  loser
end



get '/leaderboard' do
#The logic below uses the methods above to flesh out the actual outcomes in the data structure I created. The full_record variable refers to the unsorted leaderboard.
  full_record = blank_record_hash(teams_array(nfl_records))
  full_record.each do |team, record|
    if array_of_winners(nfl_records).include?(team)
      array_of_winners(nfl_records).each do |winner|
        if winner == team
          record["W"] += 1
        end
      end
    end
    if array_of_losers(nfl_records).include?(team)
      array_of_losers(nfl_records).each do |loser|
        if loser == team
          record["L"] += 1
        end
      end
    end
  end

#The following logic cleans up the data and sorts it.
  team_r = []
  full_record.each do |team, record|
    one_team = []
    one_team << team
    one_team << record["W"]
    one_team << record["L"]
    team_r << one_team
  end
  team_r.sort_by! do |wins|
    !wins[1]
  end
  team_r.sort_by! do |losses|
    losses[2]
  end
  @team_r = team_r
  erb :leaderboard
end



get '/team/:team' do
  #The logic below uses the methods above to flesh out the actual outcomes in the data structure I created. The full_record variable refers to the unsorted leaderboard.
  full_record = blank_record_hash(teams_array(nfl_records))
  full_record.each do |team, record|
    if array_of_winners(nfl_records).include?(team)
      array_of_winners(nfl_records).each do |winner|
        if winner == team
          record["W"] += 1
        end
      end
    end
    if array_of_losers(nfl_records).include?(team)
      array_of_losers(nfl_records).each do |loser|
        if loser == team
          record["L"] += 1
        end
      end
    end
  end
  @full_record = full_record
  params[:team]

  #The logic here puts the stats for each game in an easy to manage format for reporting individual game results.
  games = []
  nfl_records.each do |k|
    one_game = []
    k.each do |k, v|
      one_game << v
    end
    games << one_game
  end
  @games = games

  erb :team
end










