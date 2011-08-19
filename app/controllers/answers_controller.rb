class AnswersController < ApplicationController
  def new
    
  end
  
  def create
    question = Question.find params[:question_id]
    @answer = current_user.answers.build(params[:answer])

    respond_to do |format|
      if @answer.save
        format.html { redirect_to question, :notice => 'Answer was successfully created.' }
        format.json { render :json => @answer, :status => :created, :location => @answer }
      else
        format.html { render :action => "new" }
        format.json { render :json => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end
end
