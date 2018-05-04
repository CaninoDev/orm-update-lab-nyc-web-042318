require_relative "../config/environment.rb"
require 'pry'
class Student

  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      grade INTEGER NOT NULL);
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if @id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
      SQL
      newStud = DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, name, grade)
  end

  def self.new_from_db(attributes)
    Student.new(attributes[0], attributes[1], attributes[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?;
    SQL
    new_from_db(DB[:conn].execute(sql, name).flatten)
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM students WHERE id = ?;
    SQL
    DB[:conn].execute(sql, id)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, @name, @grade, @id)
  end
end

