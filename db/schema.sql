CREATE DATABASE business_card;

\c business_card

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT,
    password_digest TEXT,
    first_name TEXT,
    last_name TEXT
);

CREATE TABLE card_info (
    id SERIAL PRIMARY KEY,
    email TEXT,
    full_name TEXT,
    logo TEXT,
    qr_code TEXT,
    mobile INTEGER,
    website TEXT,
    business_address TEXT
);