# ---------------------------------------------------------------------
# Ask a question
# ---------------------------------------------------------------------
get "/ask_question" do
  erb :"questions/ask"
end

get "/save_question" do
  # `params` example: {"student_id" => "4", "question_text" => "Help?!"}
  
  question = Question.new(nil, params["student_id"], params["question_text"])
  
  if question.add_to_database
    "Success"
  else
    "Failure"
  end
end

# ---------------------------------------------------------------------
# List all questions
# ---------------------------------------------------------------------
get "/questions" do
  @questions = Question.all
  
  erb :"questions/index"
end