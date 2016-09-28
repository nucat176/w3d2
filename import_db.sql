CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(50),
  body TEXT,
  assoc_author_id INTEGER NOT NULL,
  FOREIGN KEY (assoc_author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT,
  subject_question_id INTEGER NOT NULL,
  parent_comment_id INTEGER,
  comment_author_id INTEGER NOT NULL,
  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_comment_id) REFERENCES replies(id),
  FOREIGN KEY (comment_author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  like_from_user_id INTEGER NOT NULL,
  liked_question_id INTEGER NOT NULL,
  FOREIGN KEY (like_from_user_id) REFERENCES users(id),
  FOREIGN KEY (liked_question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Gabriel', 'Lewis'),
  ('Adam', 'Foosaner'),
  ('Fan', 'The_Man'),
  ('Fan', 'Solo'),
  ('Fanakin', 'Skywalker'),
  ('Peter', 'Fan');

INSERT INTO
  questions (title, body, assoc_author_id)
VALUES
  ('Where do babies come from?', 'this bird and bees business confuses me', (SELECT id FROM users WHERE fname = 'Gabriel')),
  ('How far did you guys get?', 'Sorry, I just have a compulsive need to know', (SELECT id FROM users WHERE lname = 'Foosaner')),
  ('Why am I so awesome?', 'like seriously, why am I so awesome?', (SELECT id FROM users WHERE lname = 'The_Man')),
  ('Where are the keys to the Falcon?', 'DID YOU TAKE THEM??', (SELECT id FROM users WHERE lname = 'Solo')),
  ('Should I join the light or dark side?', 'srsly cant make up my mind', (SELECT id FROM users WHERE lname = 'Skywalker')),
  ('Who wants to go to Neverland??', 'its the best place everrrrr', (SELECT id FROM users WHERE lname = 'Fan'));

INSERT INTO
  question_follows(question_id, follower_id)
VALUES
  ((SELECT id FROM questions WHERE title LIKE 'Where do%' ), (SELECT id FROM users WHERE lname = 'Fan')),
  ((SELECT id FROM questions WHERE title LIKE 'How%' ), (SELECT id FROM users WHERE fname = 'Gabriel')),
  ((SELECT id FROM questions WHERE title LIKE 'Why%' ), (SELECT id FROM users WHERE fname = 'Adam')),
  ((SELECT id FROM questions WHERE title LIKE 'Where are%' ), (SELECT id FROM users WHERE fname = 'Peter')),
  ((SELECT id FROM questions WHERE title LIKE 'Should%'  ), (SELECT id FROM users WHERE fname = 'Fanakin'));


INSERT INTO
  replies(body, subject_question_id, comment_author_id, parent_comment_id)
VALUES
  ('IDK my mom told me they come from storks', (SELECT id FROM questions WHERE title LIKE 'Where do%' ),(SELECT id FROM users WHERE lname = 'Solo'), NULL),
  ('You just are, Fan. Period. End of story.', (SELECT id FROM questions WHERE title LIKE 'Why%'),(SELECT id FROM users WHERE lname = 'Foosaner'), NULL),
  ('They are under the sofa', (SELECT id FROM questions WHERE title LIKE 'Where are%'),(SELECT id FROM users WHERE lname = 'Skywalker'), NULL),
  ('I agree with Adam 100%', (SELECT id FROM questions WHERE title LIKE 'Why%'),(SELECT id FROM users WHERE lname = 'Lewis'),(SELECT id FROM replies WHERE body LIKE 'You just are%')),
  ('He lies!!!', (SELECT id FROM questions WHERE title LIKE 'Where do%'),(SELECT id FROM users WHERE lname = 'Foosaner'),(SELECT id FROM replies WHERE body LIKE 'IDK my%'));

INSERT INTO
  question_likes(like_from_user_id,liked_question_id)
VALUES

  ( (SELECT id FROM users WHERE fname = 'Gabriel'),   (SELECT id FROM questions WHERE title LIKE 'Where do%') ),
  ( (SELECT id FROM users WHERE fname = 'Fanakin'),   (SELECT id FROM questions WHERE title LIKE 'Why%') ),
  ( (SELECT id FROM users WHERE fname = 'Adam'),      (SELECT id FROM questions WHERE title LIKE 'Where do%') ),
  ( (SELECT id FROM users WHERE lname = 'Skywalker'), (SELECT id FROM questions WHERE title LIKE 'How%') ),
  ( (SELECT id FROM users WHERE lname = 'Fan'),       (SELECT id FROM questions WHERE title LIKE 'Where are%') ),
  ( (SELECT id FROM users WHERE lname = 'The_Man'),   (SELECT id FROM questions WHERE title LIKE 'Should%') ),
  ( (SELECT id FROM users WHERE lname = 'Solo'),      (SELECT id FROM questions WHERE title LIKE 'Should%') );
