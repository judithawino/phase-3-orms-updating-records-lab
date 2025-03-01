require_relative "../config/environment.rb"

class Student
    attr_accessor :name, :grade, :id
    
    def initialize(id=nil, name, grade)
      @id = id
      @name = name
      @grade = grade
    end
    def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
    end 
    def self.drop_table
      sql = <<-SQL
      DROP TABLE IF EXISTS students
      SQL
      DB[:conn].execute(sql)
    end 
    def save
      if self.id
        self.update
      else
        sql = <<-SQL
        INSERT INTO students(name, grade) 
        VALUES (?,?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        set_id
      end
    end
    def set_id
      sql = <<-SQL
      SELECT last_insert_rowid() FROM students
      SQL
      retrieved_id = DB[:conn].execute(sql)
      @id = retrieved_id[0][0]
    end
    def update
      sql = <<-SQL
      UPDATE students 
      SET name = ?, grade = ? 
      WHERE id = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end
    def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
    end
  #   def self.new_from_db(row)
  #     id= row[0]
  #     name=row[1]
  #     grade=row[2]
  #     self.new(id, name,grade)
  # end
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * 
    FROM students 
    WHERE name = ?
    LIMIT 1
    SQL
    DB[:conn].execute(sql,name).map do |row|
      new_from_db(row)
    end.first
  end
  # def self.find_by_name(name)
  #   # find the student in the database given a name
  #   # return a new instance of the Student class
  #   sql = <<-SQL
  #     SELECT *
  #     FROM students
  #     WHERE name = ?
  #     LIMIT 1
  #   SQL

  #   DB[:conn].execute(sql,name).map do |row|
  #     self.new_from_db(row)
  #   end.first
  # end




end
