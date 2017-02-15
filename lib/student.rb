require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize (id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    tables = "CREATE TABLE
    IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"

    DB[:conn].execute(tables)
  end

  def self.drop_table
    drop = "DROP TABLE students"

    DB[:conn].execute(drop)
  end

  def save
    if self.id
       self.update
    else
      save = "INSERT INTO students (name, grade) VALUES (?, ?)"

      DB[:conn].execute(save, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create (name,grade)
    student = Student.new(name,grade)
    student.save
    student
  end

    def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

    def self.new_from_db (row)
      id = row[0]
      name = row[1]
      grade = row[2]
      self.new(id,name,grade)
    end

    def self.find_by_name(name)
    name_search =
    "SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1"

    DB[:conn].execute(name_search, name).map do |row|
      binding.pry
      self.new_from_db(row)
    end.first
end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

end
