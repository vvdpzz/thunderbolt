class AcceptAnswer
  @queue = :accept_answer

  def self.perform(question_id, answer_id)
    question = Question.find question_id
    answer = Answer.find answer_id
    hash = {
      :question_id => question_id, :question_title => question.title,
      :answer_id => answer_id, :answer_content => answer.content,
      :auser_id => answer.user.id, :auser_realname => answer.user.realname,
      :auser_aboutme => answer.user.aboutme,
      :auser_avatar => answer.user.gravatar_url(:size => 32)
    }
    question.follow_user_ids.each do |user_id|
      Watch.create(:user_id => user_id, :question_id => question_id, :content => MultiJson.encode(hash))
    end
  end
end