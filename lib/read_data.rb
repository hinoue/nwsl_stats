require 'date'
require 'json'
abbreviations = 
{
  'Wake' => "Sahlen's Stadium at WakeMed Soccer Park",
  'OCS'  => "Orlando City Stadium",
  'UW'   => "UW Medicine Pitch at Memorial Stadium",
  'BBVA' => "BBVA Compass Stadium",
  'Mary' => "Maureen Hendricks Field Maryland SoccerPlex",
  'Rio'  => "Rio Tinto Stadium",
  'Toy'  => "Toyota Park",
  'Yur'  => "Yurcak Field",
  'Prov' => "Providence Park",
  'Audi' => "Audi Field",
  'HEB'  => "H-E-B Park",
  'Jordan' => "Jordan Field",
  'Swope'  => "Children's Mercy Victory Field at Swope Soccer Village",
  'Camp'   => "Camping World Stadium",
  'Capelli' => "Capelli Sport Stadium",

  'NCC'  => "North Carolina Courage",
  'SR'   => "Seattle Reign FC",
  'OP'   => "Orlando Pride",
  'CRS'  => "Chicago Red Stars",
  'PT'   => "Portland Thorns FC",
  'SB'   => "Sky Blue FC",
  'WS'   => "Washington Spirit",
  'UR'   => "Utah Royals FC",
  'HD'   => "Houston Dash",
  'BB'   => "Boston Breakers",
  'KC'   => "FC Kansas City",
  'NYF'  => "Western New York Flash"
}

id_map = 
{
  'Utah Royals FC' => 767,
  'North Carolina Courage' => 766,
  'Portland Thorns FC' =>  765,
  'Orlando Pride' => 764,
  'Sky Blue FC' => 763,
  'Houston Dash' => 762,
  'Chicago Red Stars' => 761, 
  'Seattle Reign FC' => 760,
  'Washington Spirit' => 759, 
  'Boston Breakers' => 10001,
  'FC Kansas City' => 10002,
  'Western New York Flash' => 10003
}

i = 0
data = []
match_id = 1
re_date = /(\d?\d)-(\d?\d)-(\d\d)/
re_match = /(\w+)\s+(\d+)\s+(\w+)\s+(\d+)\s+(\w+)/
cur_date = nil
$stdin.each_line do |line|
    i += 1
    match_hash = {}
    match = re_date.match(line)
    next if line.strip() == ""
    if match
        cur_date = "20#{match[3]}-#{match[1]}-#{match[2]}"
    else
        # Parse match
        match = re_match.match(line)
        if match
            home_team = abbreviations[match[1]]
            away_team = abbreviations[match[3]]
            home_score = match[2].to_i
            away_score = match[4].to_i
            stadium = match[5]

            match_hash = {}
            match_hash['match_id'] = match_id
            match_id += 1
 
            match_hash['match_date'] = cur_date
            match_hash['kick_off'] = nil
            match_hash['competition'] = { 'competition_id' => 49,
                                          'country_name' => "United States of America",
                                          "competition_name" => "NWSL" }
            match_hash['season'] = { 'season_id' => 3, "season_name" => "2018" }
           
            match_hash['home_team'] = { 'home_team_id' => id_map[home_team], 'home_team_name' => home_team }
            match_hash['away_team'] = { 'away_team_id' => id_map[away_team], 'away_team_name' => away_team }
            match_hash['home_score'] = home_score
            match_hash['away_score'] = away_score
            match_hash['stadium_name'] = abbreviations[stadium]
            match_hash['referee_name'] = nil
            match_hash['match_status'] = 'unavailable'
            match_hash['last_updated'] = DateTime.now().to_s
            match_hash['data_version'] = '1.0.2' 
            data.push(match_hash)
        else
           puts "ERROR line #{i}: #{line}"
        end
    end
end

puts JSON.pretty_generate(data)
