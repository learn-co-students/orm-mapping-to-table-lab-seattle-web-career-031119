require_relative "../config/environment.rb"
require "pry"

class Student
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute(
      <<-SQL
        CREATE TABLE students (id INTEGER PRIMARY KEY,
          name TEXT, grade TEXT);
      SQL
    )
  end

  def self.drop_table
    DB[:conn].execute(
      <<-SQL
        DROP TABLE students;
      SQL
    )
  end

  def save
    #binding.pry
    sql =
    <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  end

  def self.create(input_hash)

    new_student = Student.new(nil, input_hash[:name], input_hash[:grade])
    new_student.save
    new_student
  end

end
