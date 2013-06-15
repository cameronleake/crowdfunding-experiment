# ENVIRONMENTAL VARIABLES

# Rounds
NUMBER_OF_ROUNDS = 20
AMOUNT_DONOR_CAN_DONATE_PER_ROUND = 100                    
ROUND_PART_A1_COUNTDOWN_SECONDS = 20
ROUND_PART_A2_COUNTDOWN_SECONDS = 40
ROUND_PART_B_COUNTDOWN_SECONDS = 60

# Users
NUMBER_OF_CREATORS = 4
NUMBER_OF_DONORS = 8 
NUMBER_SPECIAL_DONORS_PER_GROUP = 2             # These donors will recieve the "special", larger return when a project is funded.     
NUMBER_OF_USERS = NUMBER_OF_CREATORS + NUMBER_OF_DONORS
CREDITS_TO_DOLLAR_RATE = 350  
                                                                
# Groups
NUMBER_OF_GROUPS = 2
NUMBER_OF_USERS_PER_GROUP = NUMBER_OF_USERS / NUMBER_OF_GROUPS    
NUMBER_OF_CREATORS_PER_GROUP = NUMBER_OF_CREATORS / NUMBER_OF_GROUPS
NUMBER_OF_DONORS_PER_GROUP = NUMBER_OF_DONORS / NUMBER_OF_GROUPS

# Projects
ALLOWED_NUMBER_OF_PROJECTS_PER_CREATOR = 4 
COST_TO_CREATE_PROJECT = 50  
AMOUNT_CREATOR_CAN_SPEND_PER_ROUND = ALLOWED_NUMBER_OF_PROJECTS_PER_CREATOR * COST_TO_CREATE_PROJECT   

HIGH_VALUE_PROJECT_GOAL = 200
STANDARD_RETURN_AMOUNT_HIGH_VALUE_POPULAR = 100
STANDARD_RETURN_AMOUNT_HIGH_VALUE_NICHE = 50
SPECIAL_RETURN_AMOUNT_HIGH_VALUE_NICHE = 200

LOW_VALUE_PROJECT_GOAL = 100   
STANDARD_RETURN_AMOUNT_LOW_VALUE_POPULAR = 50
STANDARD_RETURN_AMOUNT_LOW_VALUE_NICHE = 25
SPECIAL_RETURN_AMOUNT_LOW_VALUE_NICHE = 100

require 'csv'    
$project_names = []
CSV.foreach("colors4.csv", :headers => false) do |row|
  $project_names << row[0]
end

$project_names.each do |n|
	n.gsub!(";",'')
end


# if Rails.env.production?      # <TODO CL> Replace with inbuilt survey
#   TOKEN_SOURCE = 'tokens.csv'
# else
#   TOKEN_SOURCE = 'dummyTokens.csv'
# end

# $tokens = []                   # <TODO CL> Replace with inbuilt survey
# #CSV.foreach("tokens.csv", :headers => false) do |row|
# CSV.foreach(TOKEN_SOURCE, :headers => false) do |row|
#   $tokens << row[0]
# end