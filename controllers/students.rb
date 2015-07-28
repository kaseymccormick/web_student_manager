# ---------------------------------------------------------------------
# Add a student
# ---------------------------------------------------------------------

# Step 1: Display a form into which the user will add new student info.
get "/add_student" do
  erb :"students/add_student_form"
end

# Step 2: Take the information they submitted and use it to create new record.
get "/save_student" do
  # Since the form's action was "/save_student", it sent its values here.
  #
  # Sinatra stores them for us in `params`, which is a hash. Like this:
  #
  # {"name" => "Beth", "age" => "588"}
  
  # So using `params`, we can run our class/instance methods as needed
  # to create a student record.

  @new_student = Student.new({"name" => params["name"], "age" => params["age"].to_i})
  
  if @new_student.add_to_database
    erb :"students/student_added"
  else
    @error = true
    
    erb :"students/add_student_form"
  end
end



# ---------------------------------------------------------------------
# Change student's name
# ---------------------------------------------------------------------

# Step 1: List all students.
# 
# Each student in the ERB is linked to a route that displays a
# form to collect their new name.
get "/students" do
  erb :"students/students"
end

# Step 2: Display a form into which the user types in a student's new name.
# 
# This route handler is activated when one of the
# links (from Step 1) is clicked.
# 
# Example of this path: "/change_student_name_form/3"
get "/change_student_name_form/:x" do
  # The actual value of ':x' is stored in params.
  # So using the example path I've given here,
  # `params` equals {"x" => "3"}
  
  # We don't *need* the student's ID here, because we're just collecting
  # the student's new name. But we will need the student's ID in the next
  # step, so we must collect it here in order to pass it along to the 
  # next route.
  
  # This ERB shows a form into which the student's new name is typed.
  # Check the ERB file for more documentation.
  erb :"students/change_name_form"
end

# Step 3: Take the new name and update the correct student's record.
# 
# The form on the previous page had a hidden field that contained
# the student's ID.
# 
# So we have a student's ID and the student's new name. That's enough
# information for us to change the database correctly!
get "/change_student_name" do
  # `params` stores information from the form's submitted information.
  # So right now, `params` is {"x" => "3", "name" => "Marlene"} (for example).
  
  student = Student.find_as_object(params["x"].to_i)
  student.name = params["name"]
  student.save
  
  # TODO - Send the user somewhere nice after they successfully
  # accomplish this name change.
end