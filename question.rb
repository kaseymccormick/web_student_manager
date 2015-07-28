class Question
  attr_reader :id
  attr_accessor :student_id, :content
  
  def initialize(id=nil, student_id=nil, content=nil)
    @id = id
    @student_id = student_id
    @content = content
  end
  
  def student
    Student.find_as_object(@student_id)
  end
  
  def valid?
    valid = true
    
    # If no such student exists...
    student_result = CONNECTION.execute("SELECT * FROM students WHERE id = #{@student_id};")
    
    if student_result.empty?
      valid = false
    end
    
    # If content is blank...
    if @content.nil? || @content == ""
      valid = false
    end
    
    # If question is a duplicate from the same student.
    existing_question = CONNECTION.execute("SELECT * FROM questions WHERE content = '#{@content}' AND student_id = #{@student_id};")
    
    if !existing_question.empty?
      valid = false
    end
    
    return valid
  end
  
  def add_to_database
    # Validate for:
    # - Student exists
    # - Content is not blank
    # - Question is not a duplicate
    
    if self.valid?
      CONNECTION.execute("INSERT INTO questions (student_id, content) VALUES (#{@student_id}, '#{@content}');")
  
      @id = CONNECTION.last_insert_row_id
    else
      false
    end
  end
  
  def self.all
    results = CONNECTION.execute('SELECT * FROM questions;')
    
    results_as_objects = []
    
    results.each do |result_hash|
      results_as_objects << Question.new(result_hash["id"], result_hash["student_id"], result_hash["content"])
    end
    
    return results_as_objects
  end

  def self.add(student_id, question_content)
    query_string = "INSERT INTO questions (student_id, content) VALUES (#{student_id}, '#{question_content}');"
    CONNECTION.execute(query_string)
  end
  
  # def self.questions_by_student(student_id)
  #   #
  # end
  
end