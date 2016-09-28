require_relative 'question_database'
require_relative 'user'
require_relative 'reply'
require_relative 'questionfollow'

class Question

  def self.all
    questions = QuestionDatabase.instance.execute("SELECT * FROM questions")
    questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = :id
      SQL

    return nil if question.empty?
    Question.new(question.first)
  end

  # EASY
  def self.find_by_author_id(id)
    questions = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        assoc_author_id = :id
      SQL

    return nil if questions.empty?
    questions.map {|question| Question.new(question)}
  end


  attr_accessor :title, :body, :assoc_author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @assoc_author_id = options['assoc_author_id']
  end

  def author
    User.find_by_id(@assoc_author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  # MEDIUM

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

end
