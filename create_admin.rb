require 'sqlite3'
require 'rubygems'

#db = SQLite3::Database.new('development.sqlite3')

#query = db.execute("UPDATE users set admin='true' where email='cpx0rpc@tamu.edu';")
#query = db.execute("SELECT * from users;")
#puts query

team_id = 1
cmd = "tar czf ./public/uploads/"+team_id.to_s+".tar.gz"+" ./public/uploads/"+team_id.to_s

system(cmd)
