class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  require 'sqlite3'
  require_relative '../lib/student'

  DB = {:conn =>
  	SQLite3::Database.new("db/students.db")}

  def initialize(name, grade, id=nil)
  	@name = name
  	@grade = grade
  	# @id = id
  end

  attr_accessor :name, :grade
  attr_reader :id

  def self.create_table
  	create  = <<-SQL
  		CREATE TABLE IF NOT EXISTS students (
  		id INTEGER PRIMARY KEY,
  		name TEXT,
  		grade INTEGER
  		);
  	SQL

  	DB[:conn].execute(create)  	
  end

  def self.drop_table
  	drop = <<-SQL
  		DROP TABLE students;
  	SQL

  	DB[:conn].execute(drop)
  end

  def save
  	insert = <<-SQL
  		INSERT INTO students (name, grade)
  		VALUES (?,?)
  	SQL

  	DB[:conn].execute(insert, self.name, self.grade)

  	@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name, grade)
  	student = Student.new(name, grade)
  	student.save
  	student
  end
  
end
