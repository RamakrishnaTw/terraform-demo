CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  publication_year INT,
  price DECIMAL(10, 2),
  last_updated TIMESTAMP DEFAULT NOW()
);

INSERT INTO books (title, author, publication_year, price)
VALUES
  ('Book 1', 'Author 1', 2020, 19.99),
  ('Book 2', 'Author 2', 2018, 24.99),
  ('Book 3', 'Author 3', 2021, 29.99);
