#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
# insert into the teams table
cat games.csv | while IFS="," read YEAR ROUND TEAM1 TEAM2 WINNER OPPONENT
do
if [[ $TEAM1 != 'winner' ]]
then
  TEAM1_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM1'")
  #if team1 id not found
  if [[ -z $TEAM1_ID ]]
  then
    #insert team1 into the table
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM1')")
  fi
  TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM2'")
  #if team2 id not found
  if [[ -z $TEAM2_ID ]]
  then
    #insert team2 into the table
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM2')")
  fi
  if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
  then
    echo Inserted into teams, $INSERT_TEAM_RESULT
  fi
fi
done
# insert into the games table
cat games.csv | while IFS="," read YEAR ROUND TEAM1 TEAM2 WINNER OPPONENT
do
if [[ $YEAR != 'year' ]]
then
  # search the winner team id,opponent team id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM1'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM2'")
  # insert the first column
  INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER,$OPPONENT)")
  if [[ $INSERT_RESULT == 'INSERT 0 1' ]]
  then
    echo Inserted into games, $INSERT_RESULT
  fi
fi
done
