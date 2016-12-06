Requirements To Run The API:
 - Get Ruby installed (try and get 2.2 or later, needed for JSON gem)
 - Get Bundler installed (you can installed this by typing "gem install bundler" or "sudo gem install bundler")
 - Run 'bundle' (the bundle command installs all gems associated with the project)

How To Run The Server:
 Here is your command to start the server: (just navigate to the folder with api.rb)
  ruby api.rb -o 0.0.0.0
 After that is done, get your IPv4 address:
  For example, 64.113.71.226
 Create a "base url" that looks like the following:
  http://64.113.71.226:4567
 The IPv4 address will change depending on who is running the server / where the server is being ran.

How To Use The Server:

 GET


  /login/:username/:password
   - Replace :username with whatever the user's username is and :password with whatever the user's password is.
   - This will get the username and password for the user. This will return an array of JSON objects.
   - If the username or password was incorrect, the array will be empty.
  Example Input
   - http://64.113.71.226:4567/login/JoeyIsAwesome/potatocannon
  Example Output
  [
   {
    "user_id": 1098343,
    "name": "Joey Elliott"
   }
  ]


  /get/users/userid/:username
   - Replace :username with whatever the user's username is.
   - This will get the user id for the user. This will return an array of JSON objects.
  Example Input
   - http://64.113.71.226:4567/get/users/userid/JoeyIsAwesome
  Example Output
  [
   {
    "user_id": 1098343
   }
  ]


  /get/hiscores/animal
   - This will get the list of hiscores for the animal game. This will return an array of JSON objects.
   - Index 0 is the person in first place. Note that this is sorted only by score. (Higher score = lower index)
  Example Input
   - http://64.113.71.226:4567/get/hiscores/animal
  Example Output
  [
   {
    "difficulty": 1,
    "score": 10,
    "player_id": 1558981
   }
  ]


  /get/hiscores/shape
   - This will get the list of shape for the animal game. This will return an array of JSON objects.
   - Index 0 is the person in first place. Note that this is only sorted by score. (Higher score = lower index)
  Example Input
   - http://64.113.71.226:4567/get/hiscores/shape
  Example Output
  [
   {
    "difficulty": 3,
    "score": 15,
    "player_id": 1558981
   }
  ]


  /get/hiscores/alphabet
   - This will get the list of alphabet for the animal game. This will return an array of JSON objects.
   - Index 0 is the person in first place. Note that this is only sorted by time. (Smaller time = lower index)
  Example Input
   - http://64.113.71.226:4567/get/hiscores/alphabet
  Example Output
  [
   {
    "difficulty": 3,
    "time": 1500000,
    "player_id": 1558981
   }
  ]


  /get/hiscores/matching
   - This will get the list of matching for the animal game. This will return an array of JSON objects.
   - Index 0 is the person in first place. Note that this is only sorted by time. (Smaller time = lower index)
  Example Input
   - http://64.113.71.226:4567/get/hiscores/matching
  Example Output
  [
   {
    "difficulty": 3,
    "time": 1500500,
    "player_id": 1558981
   }
  ]


 POST


  /post/users/newuser
   - This will add a new user to the database.
  Example Input
   - http://64.113.71.226:4567/post/users/newuser
   {
    "username": "testusername",
    "password": "testpassword",
    "name": "testname"
   }
  Example Output
  {
   "status": "201 - Successfully created new user."
  }
  {
   "status": "409 - Error: User information may already exists."
  }


  /post/hiscores/animal
   - This will add a new hiscore to the animal table.
  Example Input
   - http://64.113.71.226:4567/post/hiscores/animal
   {
    "difficulty": 1,
    "score": 100,
    "user_id": 999
   }
  Example Output
  {
   "status": "201 - Successfully created new hiscore."
  }


  /post/hiscores/shape
   - This will add a new hiscore to the shape table.
  Example Input
   - http://64.113.71.226:4567/post/hiscores/shape
   {
    "difficulty": 1,
    "score": 100,
    "user_id": 999
   }
  Example Output
  {
   "status": "201 - Successfully created new hiscore."
  }

  /post/hiscores/alphabet
   - This will add a new hiscore to the alphabet table.
  Example Input
   - http://64.113.71.226:4567/post/hiscores/alphabet
   {
    "difficulty": 1,
    "time": 10000,
    "user_id": 999
   }
  Example Output
  {
   "status": "201 - Successfully created new hiscore."
  }


  /post/hiscores/matching
   - This will add a new hiscore to the matching table.
  Example Input
   - http://64.113.71.226:4567/post/hiscores/matching
   {
    "difficulty": 1,
    "time": 10000,
    "user_id": 999
   }
  Example Output
  {
   "status": "201 - Successfully created new hiscore."
  }
