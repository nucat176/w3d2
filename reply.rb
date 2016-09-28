require_relative 'question_database'
require 'byebug'
class Reply

  def self.all
    replies = QuestionDatabase.instance.execute("SELECT * FROM replies")
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_id(id)
    reply = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = :id
      SQL

    return nil if reply.empty?
    Reply.new(reply.first)
  end

  #EASY
  def self.find_by_user_id(user_id)
    replies = QuestionDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.comment_author_id = :user_id
      SQL
    return nil if replies.empty?
    replies.map {|reply| Reply.new(reply)}
  end

  def self.find_by_question_id(question_id)
    reply = QuestionDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.subject_question_id = :question_id
      SQL

      return nil if reply.empty?
      Reply.new(reply.first)
  end

  attr_accessor :body, :subject_question_id, :parent_comment_id, :comment_author_id

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @subject_question_id = options['subject_question_id']
    @parent_comment_id = options['parent_comment_id']
    @comment_author_id = options['comment_author_id']
  end




  def author
    raise "#{self} not in database" unless @id
    author = QuestionDatabase.instance.execute(<<-SQL, @comment_author_id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
      SQL

    User.new(author)
  end

  def question
    raise "#{self} not in database" unless @id
    question = QuestionDatabase.instance.execute(<<-SQL, @subject_question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
      SQL

    Question.new(question)
  end

  def parent_reply
    raise "#{self} not in database" unless @id
    parent_reply = QuestionDatabase.instance.execute(<<-SQL, @parent_comment_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
      SQL

      # byebug
    return nil if parent_reply.empty?
    Reply.new(parent_reply)
  end

  def child_replies
    # Only do child replies one-deep; don't find grandchild comments.
    child_replies = QuestionDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_comment_id = ?
      SQL

    return nil if child_replies.empty?
    child_replies.map {|child_reply| Reply.new(child_reply)}
  end

end
