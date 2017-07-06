CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(400),
  username VARCHAR(200),
  password_digest TEXT,
  age INTEGER,
  location VARCHAR(400)
)

CREATE TABLE events(
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  name VARCHAR(400),
  image_url TEXT,
  event_type_id INTEGER,
  highlights VARCHAR(400),
  description TEXT
)

CREATE TABLE event_types(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(400)
)

CREATE TABLE reviews(
  id SERIAL4 PRIMARY KEY,
  description TEXT,
  user_id INTEGER
)

CREATE TABLE comments(
  id SERIAL4 PRIMARY KEY,
  description TEXT,
  user_id INTEGER
)

CREATE TABLE event_participants(
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  event_id INTEGER
)
