#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# emptying rows in tables in database
echo $($PSQL "TRUNCATE TABLE games, teams")
#looking into games.csv and setting the delimiter
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team name
    TEAM_ONE_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $TEAM_ONE_NAME ]]
    then    
      # insert winner
      INSERT_TEAM_ONE_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_ONE_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    #get team name
    TEAM_TWO_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM_TWO_NAME ]]
    then    
      # insert opponent
      INSERT_TEAM_TWO_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_TWO_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi

  if [[ $YEAR != "year" ]]
  then
    # get winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") 
    # get opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 
    # insert game details
    INSERT_GAME_DETAILS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID,  $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_DETAILS == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID  $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi

done





 
