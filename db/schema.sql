CREATE DATABASE business_card;

\c business_card

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT,
    password_digest TEXT,
    first_name TEXT,
    last_name TEXT,
    saved_cards INT []
);

CREATE TABLE card_info (
    id SERIAL PRIMARY KEY,
    users_id INT,
    email TEXT,
    full_name TEXT,
    logo TEXT,
    qr_code TEXT,
    mobile BIGINT,
    website TEXT,
    business_address TEXT
);
