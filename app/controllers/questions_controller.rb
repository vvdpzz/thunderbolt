class QuestionsController < ApplicationController
  set_tab :questions
  
  set_tab :paid,  :segment, :only => %w(index)
  set_tab :free,  :segment, :only => %w(free)
  set_tab :watch, :segment, :only => %w(watch)
  
  def index
    @questions = Question.paid.page(params[:page]).per(3)

    respond_to do |format|
      format.html
      format.json { render :json => @questions }
    end
  end

  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @question }
    end
  end
  
  def free
    @questions = Question.free
  end

  def new
    @question = Question.new

    respond_to do |format|
      format.html
      format.json { render :json => @question }
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = current_user.questions.build(params[:question])

    respond_to do |format|
      if @question.save
        @question.not_free? and @question.deduct_credit and @question.deduct_money and @question.order_credit and @question.order_money
        format.html { redirect_to @question, :notice => 'Question was successfully created.' }
        format.json { render :json => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, :notice => 'Question was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :ok }
    end
  end
  
  def follow
    question = Question.find params[:id]
    followed = true
    if question
      records = FollowedQuestion.where(:user_id => current_user.id, :question_id => question.id)
      if records.empty?
        current_user.followed_questions.create(:question_id => question.id)
      else
        record = records.first
        followed = record.followed if record.update_attribute(:followed, !record.followed)
      end
      render :json => {:followed => followed}
    end
  end
  
  def favorite
    question = Question.find params[:id]
    favorited = true
    if question
      records = FavoriteQuestion.where(:user_id => current_user.id, :question_id => question.id)
      if records.empty?
        current_user.favorite_questions.create(:question_id => question.id)
      else
        record = records.first
        favorited = record.favorited if record.update_attribute(:favorited, !record.favorited)
      end
      render :json => {:favorited => favorited}
    end
  end
end
