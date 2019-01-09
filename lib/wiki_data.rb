require 'open-uri'
require 'json'
require 'prettyprint'

team_url_base = [ 
"Western_New_York_Flash",
"Boston_Breakers",
"FC_Kansas_City",
"Portland_Thorns_FC",
]

def parse_line(line)
    key, value = line[1..-1].split('=', 2)
    return key.strip(), value.strip()
end

def parse_data(data)
    results = []
    cur_match = nil
    data.each_line do |line|
        if line.start_with?("{{")
            cur_match = {}
        elsif line.start_with?("}}")
            results.push(cur_match)
            cur_match = nil
        elsif line.start_with?("|")
           key, value = parse_line(line)
           cur_match[key] = value
        end
    end 
    results
end

url = "https://en.wikipedia.org/w/index.php?title=2013_Western_New_York_Flash_season&action=edit"

page = open(url).read()

regular_results = false
playoff_results = false

regular_data = ""
playoff_data = ""
i = 0
page.each_line do |line|
    i += 1
    if line.start_with?("===")
        regular_results = false
        playoff_results = false
    end

    if line.strip().downcase() == "===regular season==="
        regular_results = true 
    elsif line.strip().downcase() == "===playoffs==="
        playoff_results = true 
    end

    #puts "#{regular_results} #{playoff_results} #{line}"

    if regular_results
        regular_data += line
    elsif playoff_results
        playoff_data += line 
    end
end

regular_results = parse_data(regular_data)
playoff_results = parse_data(playoff_data)

pp regular_results
