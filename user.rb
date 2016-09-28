require_relative 'question'
require_relative 'question_database'
require_relative 'reply'
require_relative 'questionfollow'
class User

  def self.all
    users = QuestionDatabase.instance.execute("SELECT * FROM users")
    users.map { |user| User.new(user) }
  end

  def self.find_by_id(id)
    user = QuestionDatabase.instance.execute(<<-SQL, id: id)
    SELECT
    *
    FROM
    users
    WHERE
    users.id = :id
    SQL

    return nil if user.empty?
    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    users = QuestionDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
    SELECT
      *
    FROM
      users
    WHERE
      users.fname = :fname AND
      users.lname = :lname
    SQL
    return nil if users.empty?
    users.map {|user| User.new(user)}
  end

  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end


  # EASY

  def authored_questions
    # (use Question::find_by_author_id)
    Question.find_by_author_id(@id)
  end

  def authored_replies
    # (use Reply::find_by_user_id)
    Reply.find_by_user_id(@id)
  end

  # MEDIUM

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end



end
