require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Student
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id
  attr_accessor :name, :age
  
  # Initializes a new student object.
  #
  # student_options - Hash containing key/values.
  #   - id (optional)   - Integer of the student record in the 'students' table.
  #   - name (optional) - String of the student's name.
  #   - age (optional)  - Integer of the student's age.
  #
  # Examples:
  #
  #   Student.new({"id" => 50, "name" => "Sumeet", "age" => 450})
  #   => #<Student:f7834h7f8> 
  #
  # Returns a Student object.
  # def initialize(student_id=nil, name=nil, age=nil)
  def initialize(student_options={})
    @id = student_options["id"]
    @name = student_options["name"]
    @age = student_options["age"]
  end
  
  # Find a student based on their ID.
  #
  # student_id - The Integer ID of the student to return.
  #
  # Returns a Student object.
  def self.find_as_object(student_id)
    # CONNECTION.execute returns an Array of Hashes, like:
    # [{"id" => 1, "name" => "Sumeet", "age" => 500}]

    # Here, I'm using the `find` method from DatabaseClassMethods.
    result = Student.find(student_id).first
    # {"id" => 1, "name" => "Sumeet", "age" => 500}

    Student.new(result)
  end
  
  # Get all student records, sorted by age, from the database.
  #
  # Returns an Array containing Student objects.
  def self.all_sorted_by_age
    results = CONNECTION.execute('SELECT * FROM students ORDER BY age ASC;')
    
    results_as_objects = []
    
    results.each do |result_hash|
      results_as_objects << Student.new(result_hash)
    end
    
    return results_as_objects
  end
  
  # Adds a row to the "students" table, using this object's attribute values.
  #
  # TODO - Is the other `add` method even needed?
  #
  # Returns the Integer ID that the database sends back.
  def add_to_database
    if self.can_drink?
      CONNECTION.execute("INSERT INTO students (name, age) VALUES ('#{@name}', #{@age});")
    
      @id = CONNECTION.last_insert_row_id
    else
      false
    end
  end

  # # Add a new student to the database.
  # #
  # # student_name (optional) - String of the student's name.
  # # student_age (optional)  - Integer of the student's age.
  # #
  # # Returns a Student object.
  # def self.add(student_name, student_age)
  #   CONNECTION.execute("INSERT INTO students (name, age) VALUES ('#{student_name}', #{student_age});")
  #
  #   student_id = CONNECTION.last_insert_row_id
  #
  #   Student.new({"id" => student_id, "name" => student_name, "age" => student_age})
  # end
  
  # Updates the database with all values for the student.
  #
  # Returns an empty Array. TODO - This should return something better.
  def save
    CONNECTION.execute("UPDATE students SET name = '#{@name}', age = #{@age} WHERE id = #{@id};")
  end
  
  # Check if a student can drink.
  #
  # Returns Boolean.
  def can_drink?
    @age >= 21
  end
  
  # Get all of a student's questions.
  #
  # Returns an Array containing Hashes of the questions table's rows.
  def questions
    results = CONNECTION.execute("SELECT * FROM questions WHERE student_id = #{@id};")
    
    results_as_objects = []
    
    results.each do |result_hash|
      results_as_objects << Question.new(result_hash["id"], result_hash["student_id"], result_hash["content"])
    end
    
    return results_as_objects
  end
  
  # # Refactored, DRYer version:
  #
  # def field_value(name_of_field)
  #   result = CONNECTION.execute("SELECT #{name_of_field} FROM students WHERE id = #{@id};")
  #   result.first[name_of_field]
  # end
  #
  # def name
  #   self.field_value("name")
  # end
  #
  # def age
  #   self.field_value("age")
  # end
end












