require 'sinatra'
require 'sqlite3'
require 'json'

# Open the database
db = SQLite3::Database.open 'database.db'



# ----- GET REQUESTS ----- #

# ----- GET REQUESTS ----- #



get '/login/:username/:password' do
  # Yes I realize this is arguably the worst way to do this, but I'm trying to get this done on time
  table = db.execute "select user_id, name from users where username = '#{params[:username]}' and password = '#{params[:password]}';"
  JSON.pretty_generate convert_table_to_array_of_hashes table, %w(user_id name)
end

get '/get/users/userid/:username' do
  table = db.execute "select user_id from users where username = '#{params[:username]}';"
  JSON.pretty_generate convert_table_to_array_of_hashes table, %w(user_id)
end

get '/get/hiscores/animal' do
  table = db.execute 'select * from animal order by score desc;'
  JSON.pretty_generate convert_table_to_array_of_hashes table, %w(difficulty score player_id)
end

get '/get/hiscores/shape' do
    table = db.execute 'select * from shape order by score desc;'
    JSON.pretty_generate convert_table_to_array_of_hashes table, %w(difficulty score player_id)
end

get '/get/hiscores/alphabet' do
    table = db.execute 'select * from alphabet order by time asc;'
    JSON.pretty_generate convert_table_to_array_of_hashes table, %w(difficulty time player_id)
end

get '/get/hiscores/matching' do
    table = db.execute 'select * from matching order by time asc;'
    JSON.pretty_generate convert_table_to_array_of_hashes table, %w(difficulty time player_id)
end



# ----- POST REQUESTS ----- #

# ----- POST REQUESTS ----- #



# POST request for adding a new user to the database.
post '/post/users/newuser' do
  return_message = {}

  payload = JSON.parse request.body.read, :symbolize_names => true

  if (payload.has_key?(:username) && payload.has_key?(:password) && payload.has_key?(:name))
    return_message[:status] = '200 - OK'
    begin
      db.execute "insert into users values (#{generate_random_user_id db}, '#{payload[:username]}', '#{payload[:password]}', '#{payload[:name]}');"
    rescue SQLite3::ConstraintException
      return_message[:status] = '409 - Error: User information may already exists.'
      return JSON.pretty_generate return_message
    end
    return_message[:status] = '201 - Successfully created new user.'
  else
    return_message[:status] = '400 - Error: Invalid JSON file.'
  end

  JSON.pretty_generate return_message
end

# POST request for adding a new hiscore to the animal table in the database.
post '/post/hiscores/animal' do
  return_message = {}

  payload = JSON.parse request.body.read, :symbolize_names => true

  if (payload.has_key?(:difficulty) && payload.has_key?(:score) && payload.has_key?(:user_id))
    return_message[:status] = '200 - OK'
    db.execute "insert into animal values (#{payload[:difficulty]}, #{payload[:score]}, #{payload[:user_id]});"
    return_message[:status] = '201 - Successfully created new hiscore.'
  else
    return_message[:status] = '400 - Error: Invalid JSON file.'
  end

  JSON.pretty_generate return_message
end

# POST request for adding a new hiscore to the shape table in the database.
post '/post/hiscores/shape' do
  return_message = {}

  payload = JSON.parse request.body.read, :symbolize_names => true

  if (payload.has_key?(:difficulty) && payload.has_key?(:score) && payload.has_key?(:user_id))
    return_message[:status] = '200 - OK'
    db.execute "insert into shape values (#{payload[:difficulty]}, #{payload[:score]}, #{payload[:user_id]});"
    return_message[:status] = '201 - Successfully created new hiscore.'
  else
    return_message[:status] = '400 - Error: Invalid JSON file.'
  end

  JSON.pretty_generate return_message
end

# POST request for adding a new hiscore to the alphabet table in the database.
post '/post/hiscores/alphabet' do
  return_message = {}

  payload = JSON.parse request.body.read, :symbolize_names => true

  if (payload.has_key?(:difficulty) && payload.has_key?(:time) && payload.has_key?(:user_id))
    return_message[:status] = '200 - OK'
    db.execute "insert into alphabet values (#{payload[:difficulty]}, #{payload[:time]}, #{payload[:user_id]});"
    return_message[:status] = '201 - Successfully created new hiscore.'
  else
    return_message[:status] = '400 - Error: Invalid JSON file.'
  end

  JSON.pretty_generate return_message
end

# POST request for adding a new hiscore to the matching table in the database.
post '/post/hiscores/matching' do
  return_message = {}

  payload = JSON.parse request.body.read, :symbolize_names => true

  if (payload.has_key?(:difficulty) && payload.has_key?(:time) && payload.has_key?(:user_id))
    return_message[:status] = '200 - OK'
    db.execute "insert into matching values (#{payload[:difficulty]}, #{payload[:time]}, #{payload[:user_id]});"
    return_message[:status] = '201 - Successfully created new hiscore.'
  else
    return_message[:status] = '400 - Error: Invalid JSON file.'
  end

  JSON.pretty_generate return_message
end



# ----- HELPER METHODS ----- #

# ----- HEPLER METHODS ----- #



def generate_random_user_id(db)
  # Get all the existing user ids
  ids = []
  table = db.execute 'select user_id from users;'
  table.each do |row|
    ids.push row[0]
  end

  # Generate a user id that doesn't exist in ids
  counter = 0
  while counter < 999999 do
    val = 1000000 + Random.rand(999999)
    unless ids.include? val
      return val
    end
    counter += 1
  end
end

def convert_table_to_array_of_hashes(table, columns)
  return_array = []

  table.each do |row|
    hash = Hash.new

    row.each_with_index do |element, index|
      hash[columns[index]] = element
    end

    return_array.push hash
  end

  return return_array
end
