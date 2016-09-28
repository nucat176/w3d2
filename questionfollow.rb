require_relative 'question_database'
require_relative 'user'
require_relative 'question'
require_relative 'reply'

class QuestionFollow
  def self.all
    question_follows = QuestionDatabase.instance.execute("SELECT * FROM question_follows")
    question_follows.map { |question_follow| QuestionFollow.new(question_follow) }
  end

  def self.find_by_id(id)
    question_follow = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.id = :id
      SQL

    return nil if question_follow.empty?
    QuestionFollow.new(question_follow.first)
  end

  # MEDIUM

  def self.followers_for_question_id(question_id)
    followers = QuestionDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        question_follows qf
        INNER JOIN questions q ON q.id = qf.question_id
        INNER JOIN question_follows f ON f.question_id = q.id
        INNER JOIN users ON users.id = f.follower_id
      WHERE
        q.id = :question_id
      SQL

      return nil if followers.empty?
      followers.map {|follower| User.new(follower)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        question_follows qf
        INNER JOIN users u ON u.id = qf.follower_id
        INNER JOIN questions ON qf.question_id = questions.id
        -- INNER JOIN questions ON  = f.question_id
      WHERE
        qf.follower_id = :user_id
      SQL

      return nil if questions.empty?
      questions.map {|question| Question.new(question)}

  end

  attr_accessor :follower_id, :question_id

  def initialize(options)
    @id = options['id']
    @follower_id = options['follower_id']
    @question_id = options['question_id']
  end

end
