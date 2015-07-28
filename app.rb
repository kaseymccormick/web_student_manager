require "pry"
require "sinatra"
require "sinatra/reloader"

# Empower my program with SQLite.
require "sqlite3"

# Load/create our database for this program.
CONNECTION = SQLite3::Database.new("drakon.db")

# Make the tables.
CONNECTION.execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER);")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS questions (id INTEGER PRIMARY KEY, student_id INTEGER, content TEXT);")

# Get results as an Array of Hashes.
CONNECTION.results_as_hash = true

# ---------------------------------------------------------------------

require_relative "question.rb"
require_relative "student.rb"


# ########################### BEGIN WEB UX ############################


# ---------------------------------------------------------------------
# Menu
# ---------------------------------------------------------------------
get "/home" do
  erb :"general/homepage"
end

require_relative "controllers/questions.rb"
require_relative "controllers/students.rb"