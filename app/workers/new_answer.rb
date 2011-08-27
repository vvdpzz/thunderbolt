class NewAnswer
  @queue = :new_answer

  def self.perform(question_id, answer_id)
    question = Question.find question_id
    answer = Answer.find answer_id
    html = "<a href=\"/questions/#{question_id}\">#{question.title}</a>有了一个新答案：<a href=\"/users/#{answer.user.id}\">#{answer.user.realname}</a> #{answer.content}"
    question.follow_user_ids.each do |user_id|
      Notification.create(:user_id => user_id, :content => html)
    end
  end
end