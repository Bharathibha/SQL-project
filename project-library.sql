-- Create Database
create database library;
use library;

-- Create Tables
CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(50),
    genre VARCHAR(30),
    published_year INT
);

-- Insert sample data
INSERT INTO Book VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960),
(2, '1984', 'George Orwell', 'Dystopian', 1949),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925),
(4, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813),
(5, 'The Catcher in the Rye', 'J.D. Salinger', 'Coming-of-Age', 1951);

use library;

-- Create Member table
CREATE TABLE Member (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(50),
    member_email VARCHAR(100),
    member_phone VARCHAR(15)
);
-- Insert sample data
INSERT INTO Member VALUES
(1, 'John Doe', 'john.doe@email.com', '123-456-7890'),
(2, 'Jane Smith', 'jane.smith@email.com', '987-654-3210'),
(3, 'Bob Johnson', 'bob.johnson@email.com', '555-123-4567'),
(4, 'Alice Williams', 'alice.w@email.com', '111-222-3333'),
(5, 'Charlie Brown', 'charlie.brown@email.com', '777-888-9999');

use library;

-- Create BookLoan table
CREATE TABLE BookLoan (
    loan_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE,
    return_date DATE
);
-- Insert sample data
INSERT INTO BookLoan VALUES
(1, 1, 1, '2023-01-01', '2023-01-15'),
(2, 2, 2, '2023-02-01', '2023-02-15'),
(3, 3, 3, '2023-03-01', '2023-03-15'),
(4, 4, 4, '2023-04-01', '2023-04-15'),
(5, 5, 5, '2023-05-01', '2023-05-15');

use library;
-- Select all books
SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM BookLoan;

-- Select books published after 1960
SELECT * FROM Book WHERE published_year > 1960;

-- creating view
create view title_view as select title from book; 
SELECT * FROM title_view;

-- Update book genre
UPDATE Book SET genre = 'Literary Fiction' WHERE book_id = 1;

-- Delete a book
DELETE FROM Book WHERE book_id = 3;

-- Add a new member
INSERT INTO Member VALUES (6, 'Eva Green', 'eva.green@email.com', '555-8878-5277');

-- Select all books borrowed by a specific member
SELECT Book.title, Book.author, BookLoan.loan_date, BookLoan.return_date
FROM Book
JOIN BookLoan ON Book.book_id = BookLoan.book_id
JOIN Member ON BookLoan.member_id = Member.member_id
WHERE Member.member_name = 'John Doe';

-- Count the number of books in each genre
SELECT genre, COUNT(*) AS num_books FROM Book GROUP BY genre;

-- creating new column with default
alter table Member add location varchar(30) default("Chennai");
select* from member;

-- updating values
update member set location="erode" where member_id=2 or member_id=5;
update member set location="hydrabad" where member_id=4;

-- Find members who borrowed more than one books
SELECT * FROM Book ORDER BY published_year ASC LIMIT 1;
SELECT Member.member_name,Member.member.id, COUNT(*) AS num_books_borrowed
FROM Member
JOIN BookLoan ON Member.member_id = BookLoan.member_id
GROUP BY Member.member_name
HAVING COUNT(*) > 1;

-- Select books with 'T' in the title
SELECT * FROM Book WHERE title LIKE '%T%';
 
-- Select books borrowed in February      
SELECT Book.title, Member.member_name, BookLoan.loan_date
FROM Book
JOIN BookLoan ON Book.book_id = BookLoan.book_id
JOIN Member ON BookLoan.member_id = Member.member_id
WHERE MONTH(BookLoan.loan_date) = 2;

-- Select books borrowed by members whose name starts with 'J'
SELECT Book.title, Member.member_name
FROM Book
JOIN BookLoan ON Book.book_id = BookLoan.book_id
JOIN Member ON BookLoan.member_id = Member.member_id
WHERE Member.member_name LIKE 'J%';       

-- Use EXISTS to find books with loans
SELECT title FROM Book WHERE EXISTS (
    SELECT 5 FROM BookLoan WHERE BookLoan.book_id = Book.book_id);

-- Select all members with NULL phone numbers
SELECT * FROM Member WHERE member_phone IS NULL;

-- Select all members with NOT NULL email addresses
SELECT * FROM Member WHERE member_email IS NOT NULL;

-- adding interval and date difference
SELECT ADDDATE("2023-01-15", INTERVAL 10 DAY);
SELECT DATEDIFF('2023-04-01', '2023-04-15');

-- Find the book with the earliest published year
SELECT * FROM Book ORDER BY published_year ASC LIMIT 1;

use library;

-- giving message
DELIMITER //
create procedure notification()
BEGIN
select bookloan.loan_id,member.member_name,if(datediff(curdate(),return_date)<30,'Thank You So Much','Thank You')
as notification from bookloan join member ON Member.member_id=BookLoan.member_id;
END //
DELIMITER ;
call notification();

-- create user
create user 'library'@'localhost'identified by'bharu';
grant select,insert,delete on library.* to  'library'@'localhost';
show grants for 'library'@'localhost';