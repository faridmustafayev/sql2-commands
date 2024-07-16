CREATE TABLE persons
(
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(256),
    birth_date  DATE,
    birth_place TEXT,
    created_at  TIMESTAMP,
    age         INT,
    email       VARCHAR(256)
);

COMMENT ON TABLE persons IS 'This is a table of information about persons';

INSERT INTO persons (name, birth_date, birth_place, created_at, age, email)
VALUES ('Farid', '2002-07-08', 'Baku', now(), 21, 'feridmustafayev34@gmail.com');

INSERT INTO persons (name, birth_date, birth_place, created_at, age, email)
VALUES ('Afgan', '1999-03-31', 'Baku', now(), 24, 'afgan1999@gmail.com');

INSERT INTO persons (name, age, email)
VALUES ('Elkhan', 22, 'elkhanmemmedov@gmail.com');

INSERT INTO persons(name, birth_place, birth_date, created_at)
VALUES ('Ramiz', DEFAULT, '2005-04-03', now());

INSERT INTO persons (name, email)
VALUES (DEFAULT, 'security@gmail.com');

INSERT INTO persons
VALUES (6, 'Ramiz', DEFAULT, DEFAULT, now(), 27, 'ramizdef@gmail.com');

SELECT email AS security
FROM persons;

SELECT *
FROM persons
ORDER BY id DESC
    LIMIT 2;

SELECT *
FROM persons
ORDER BY id DESC
OFFSET 2 LIMIT 1;

SELECT *
FROM persons
ORDER BY id DESC
OFFSET 2 FETCH FIRST 1 ROWS ONLY;

SELECT *
FROM persons
WHERE name IN ('Afgan', 'Ramiz');

SELECT *
FROM persons
WHERE name NOT IN ('Afgan', 'Ramiz');

SELECT *
FROM persons
WHERE name IS NULL;

SELECT *
FROM persons
WHERE name LIKE '%r%';

SELECT *
FROM persons
WHERE name ILIKE '%r%';

CREATE TABLE companies
(
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(256)
);

COMMENT ON TABLE companies IS 'This is a table of information about companies';

INSERT INTO companies
VALUES (DEFAULT, 'Pasha Holding'),
       (DEFAULT, 'Azərsun Holding'),
       (DEFAULT, 'Gilan Holding');

SELECT name
FROM persons
UNION
SELECT name
FROM companies;

SELECT name
FROM persons
UNION ALL
SELECT name
FROM companies;

CREATE TABLE stores
(
    id                   BIGSERIAL PRIMARY KEY,
    store_name           VARCHAR(256),
    product_name         varchar(256),
    number_products_sold INT
);

COMMENT ON TABLE stores IS 'This is a table of information about stores';

CREATE TABLE clothes
(
    id                     BIGSERIAL PRIMARY KEY,
    name                   VARCHAR(256),
    dress_size_with_figure INT
);

COMMENT ON TABLE clothes IS 'This is a table of information about clothes';

-- aggregate function

SELECT COUNT(name)
FROM clothes
WHERE dress_size_with_figure < 41;

SELECT COUNT(DISTINCT name)
FROM clothes
WHERE dress_size_with_figure < 41;

SELECT AVG(dress_size_with_figure)
FROM clothes;

SELECT MIN(dress_size_with_figure)
FROM clothes;

SELECT MAX(dress_size_with_figure)
FROM clothes;

SELECT SUM(DISTINCT dress_size_with_figure)
FROM clothes;

SELECT product_name, SUM(number_products_sold)
FROM stores
GROUP BY product_name;

SELECT store_name, SUM(number_products_sold)
FROM stores
GROUP BY store_name
HAVING SUM(number_products_sold) > 44;

-- Relations(OneToOne(1:1))

CREATE TABLE users
(
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(256),
    created_at TIMESTAMP,
    email      VARCHAR(256),
    age        INT
);

CREATE TABLE id_cards
(
    id          BIGSERIAL PRIMARY KEY,
    user_id     INTEGER REFERENCES users (id),
    issue_date  DATE,
    expiry_date DATE,
    fin_code    VARCHAR(25),
    series      BIGINT
);

SELECT o.fin_code, s.name
FROM id_cards o,
     users s
WHERE o.user_id = s.id;

SELECT e.fin_code, n.name
FROM id_cards e
         INNER JOIN users n ON e.user_id = n.id;

SELECT m.series, s.email, s.name
FROM id_cards m
         LEFT JOIN users s ON m.user_id = s.id;

SELECT d.expiry_date, f.name, f.age
FROM id_cards d
         RIGHT JOIN users f ON d.user_id = f.id;

SELECT g.series, h.name, h.email
FROM id_cards g
         CROSS JOIN users h;

-- Relations (OneToMany(1:M))

CREATE TABLE countries
(
    id           BIGSERIAL PRIMARY KEY,
    country_name VARCHAR(50)
);

INSERT INTO countries
VALUES (DEFAULT, 'Azerbaijan'),
       (DEFAULT, 'USA'),
       (DEFAULT, 'UK'),
       (DEFAULT, 'Turkey');

COMMENT ON TABLE countries IS 'This is a table of information about countries';


CREATE TABLE cities
(
    id         BIGSERIAL PRIMARY KEY,
    population INT,
    city_name  VARCHAR(30),
    country_id INTEGER REFERENCES countries (id)
);

COMMENT ON TABLE cities IS 'This is a table of information about cities';

INSERT INTO cities (population, city_name, country_id)
VALUES (115000, 'Agdash', 1);

INSERT INTO cities (population, city_name, country_id)
VALUES (56900, 'Qakh', 1);

INSERT INTO cities(population, city_name, country_id)
VALUES (5747325, 'Ankara', 4);

INSERT INTO cities(population, city_name, country_id)
VALUES (2270298, 'Adana', 4);

INSERT INTO cities(population, city_name, country_id)
VALUES (8000000, 'London', 3);

INSERT INTO cities(population, city_name, country_id)
VALUES (300000, 'Brighton', 3);

INSERT INTO cities(population, city_name, country_id)
VALUES (59000000, 'Washington', 2);

SELECT s.country_name, m.city_name, m.population
FROM countries s,
     cities m
WHERE s.id = m.country_id;

SELECT s.country_name, m.city_name, m.population
FROM countries s
         INNER JOIN cities m ON s.id = m.country_id;

SELECT s.country_name, m.population
FROM countries s
         LEFT JOIN cities m ON s.id = m.country_id;

SELECT s.country_name, m.city_name
FROM countries s
         RIGHT JOIN cities m ON s.id = m.country_id;

SELECT f.country_name, g.city_name
FROM countries f
         CROSS JOIN cities g;

-- Relations (ManyToMany(M:M))

CREATE TABLE authors
(
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(50)
);

COMMENT ON TABLE authors IS 'This is a table of information about authors';

INSERT INTO authors (name)
VALUES ('J.K.Rowling');

INSERT INTO authors (name)
VALUES ('Stephen King');

INSERT INTO authors (name)
VALUES ('Agatha Christie');

CREATE TABLE books
(
    id               BIGSERIAL PRIMARY KEY,
    title            VARCHAR(40),
    publication_date DATE
);

COMMENT ON TABLE authors IS 'This is a table of information about books';

INSERT INTO books (title, publication_date)
VALUES ('Harry Potter and the Philosopher''s Stone', '1997-06-26');

INSERT INTO books (title, publication_date)
VALUES ('The Shining', '1997-01-28');

INSERT INTO books (title, publication_date)
VALUES ('Murder on the Orient Express', '1934-01-01');

CREATE TABLE authors_books
(
    id        BIGSERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors (id),
    book_id   INTEGER REFERENCES books (id)
);

COMMENT ON TABLE authors IS 'This is a table of information about author_books';

INSERT INTO authors_books (author_id, book_id)
VALUES (1, 1);

INSERT INTO authors_books (author_id, book_id)
VALUES (2, 2);

INSERT INTO authors_books (author_id, book_id)
VALUES (3, 3);

SELECT a.name AS author_name, b.title AS book_title, b.publication_date
FROM authors a
         JOIN authors_books ab ON a.id = ab.author_id
         JOIN books b ON ab.book_id = b.id
WHERE a.name = 'J.K.Rowling';

-- create sequence

CREATE TABLE customers
(
    id   INTEGER PRIMARY KEY DEFAULT nextval('next_id'),
    name VARCHAR(255)
);

INSERT INTO customers (id, name)
VALUES (nextval('next_id'), 'Resad');

INSERT INTO customers (name)
VALUES ('Jony');