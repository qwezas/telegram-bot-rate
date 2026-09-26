CREATE SCHEMA bot;

CREATE TABLE bot.groups (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    external_id BIGINT NOT NULL
);

CREATE TABLE bot.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    telegram_id BIGINT NOT NULL,
    group_id INTEGER NOT NULL REFERENCES bot.groups(id)
);

CREATE TABLE bot.media (
    id SERIAL PRIMARY KEY,
    content_url VARCHAR(250) NOT NULL,
    user_id INTEGER NOT NULL REFERENCES bot.users(id),
    group_id INTEGER NOT NULL REFERENCES bot.groups(id)
);

CREATE TABLE bot.media_ratings (
    id SERIAL PRIMARY KEY,
    score INT NOT NULL,
    media_id INT REFERENCES bot.media(id),
    user_id INT REFERENCES bot.users(id),
    created_at TIMESTAMP NOT NULL
);