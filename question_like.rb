
class QuestionLike

  def self.all
    question_likes = QuestionDatabase.instance.execute("SELECT * FROM question_likes")
    question_likes.map { |question_like| QuestionLike.new(question_like) }
  end

  def self.find_by_id(id)
    question_like = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = :id
      SQL

    return nil if question_like.empty?
    QuestionLike.new(question_like.first)
  end

  attr_accessor :like_from_user_id, :liked_question_id

  def initialize(options)
    @id = options['id']
    @like_from_user_id = options['like_from_user_id']
    @liked_question_id = options['liked_question_id']
  end

end
