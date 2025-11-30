create database Library_mangement_system ;

use Library_mangement_system ;

create table customer (
customer_id varchar(6) primary key ,
customer_name varchar(10) ,
dob date ,
location varchar(15),
mobile_no varchar(10),
occupation varchar (10)
);

insert into customer values ("00001","Ramesh",'1995-12-01',"BANGALORE",'1234568574','Engineer');
insert into customer values ("00002","Suresh",'1986-01-05',"DELHI",'2541698567','UNEMPLOYED');
insert into customer values ("00003","Amit",'1999-06-24',"MANGALORE",'6325847914','BUISNESS');
insert into customer values ("00004","Chandra",'1969-09-30',"PUNE",'3658945718','Engineer');
insert into customer values ("00005","Rahul",'1989-08-22',"CHENNAI",'9541628746','Engineer');
insert into customer values ("00006","Naveen",'1962-07-12',"HASSAN",'2584693175','SUPERVISOR');
insert into customer values ("00007","Shankar",'1998-11-08',"UDUPI",'7584632145','PRODUCTION');
insert into customer values ("00008","Nisha",'1999-12-16',"MADKERI",'7458965874','HR');
insert into customer values ("00009","Trisha",'2000-05-11',"TUMKURU",'1452365214','MANEGER');
insert into customer values ("00010","Nayantara",'1999-03-13',"DAVANGERE",'1459638521','MODEL');

select * from customer;

create table books(
Book_id varchar(6) primary key,
BOOK_NAME varchar(40),
BOOK_GENERE varchar(30)
);

insert into books values
('B001',"ASN",'FAMILY'),('B004',"VILLAN",'DARMA'),('B007',"GBU",'COMEDY'),('B010',"MAX",'ACTION'),
('B002',"RAMACHARI",'ACTION'),('B005',"ELEVEN",'SCI-FI'),('B008',"HERO",'FAMILY'),('B011',"KANTARA",'HORROR'),
('B003',"HARRY POTTER",'FANTASY'),('B006',"MASTER",'FAMILY'),('B009',"AMARAN",'ADVENTURE'),('B012',"JACK",'FAMILY');


select * from books;

CREATE TABLE subscribers (
    account_id VARCHAR(6) PRIMARY KEY,
    customer_id VARCHAR(6),
    book_id VARCHAR(6),
    account_type VARCHAR(20),
    account_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) 
);

INSERT INTO subscribers 
VALUES 
('S0001','00001','B010','PREMIUM','ACTIVE'),
('S0002','00003','B005','REGULAR','SUSPENDED'),
('S0003','00005','B001','PREMIUM','ACTIVE'),
('S0004','00006','B006','PREMIUM','TERMINATED'),
('S0005','00007','B011','REGULAR','SUSPENDED'),
('S0006','00004','B007','PREMIUM','ACTIVE'),
('S0007','00002','B004','REGULAR','TERMINATED'),
('S0008','00008','B002','PREMIUM','ACTIVE'),
('S0009','00010','B009','REGULAR','SUSPENDED'),
('S0010','00009','B003','REGULAR','ACTIVE');

select * from subscribers;

-- 2. List all customers from Bangalore
SELECT * FROM customer WHERE location = 'BANGALORE';

-- 3. Show all PREMIUM subscribers
SELECT * FROM subscribers WHERE account_type = 'PREMIUM';

-- 4. Show all ACTIVE accounts
SELECT * FROM subscribers WHERE account_status = 'ACTIVE';

-- 5. Find customers who are Engineers
SELECT * FROM customer WHERE occupation = 'Engineer';

-- 6. List books in the 'FAMILY' genre
SELECT * FROM books WHERE BOOK_GENERE = 'FAMILY';

-- 7. Join: Show subscriber name, book name, and account status
SELECT s.account_id, c.customer_name, b.BOOK_NAME, s.account_status
FROM subscribers s
JOIN customer c ON s.customer_id = c.customer_id
JOIN books b ON s.book_id = b.Book_id;

-- 8. Count of subscribers per account type
SELECT account_type, COUNT(*) AS total_subscribers
FROM subscribers
GROUP BY account_type;

-- 9. Count subscribers per book
SELECT book_id, COUNT(*) AS subscriber_count
FROM subscribers
GROUP BY book_id;

-- 10. List subscribers who are TERMINATED
SELECT * FROM subscribers WHERE account_status = 'TERMINATED';

-- =========================================
-- 🔁 JOINS (ALL TYPES)
-- =========================================

-- INNER JOIN: Subscriber names and their book names
SELECT c.customer_name, b.BOOK_NAME
FROM subscribers s
INNER JOIN customer c ON s.customer_id = c.customer_id
INNER JOIN books b ON s.book_id = b.Book_id;

-- LEFT JOIN: All subscribers and their book info (even if book missing)
SELECT s.account_id, b.BOOK_NAME
FROM subscribers s
LEFT JOIN books b ON s.book_id = b.Book_id;

-- RIGHT JOIN: All books and who subscribed them (even if unsubscribed)
SELECT b.BOOK_NAME, s.account_id
FROM books b
RIGHT JOIN subscribers s ON s.book_id = b.Book_id;

-- FULL JOIN equivalent using UNION (MySQL doesn't support FULL JOIN directly)
SELECT c.customer_name, s.account_id
FROM customer c
LEFT JOIN subscribers s ON c.customer_id = s.customer_id
UNION
SELECT c.customer_name, s.account_id
FROM customer c
RIGHT JOIN subscribers s ON c.customer_id = s.customer_id;


-- =========================================
-- 🧠 SUBQUERIES
-- =========================================

-- 1. Customers who have subscribed to a 'FAMILY' genre book
SELECT * FROM customer
WHERE customer_id IN (
  SELECT s.customer_id
  FROM subscribers s
  JOIN books b ON s.book_id = b.Book_id
  WHERE b.BOOK_GENERE = 'FAMILY'
);

-- 2. Book with the highest number of subscriptions
SELECT * FROM books
WHERE Book_id = (
  SELECT book_id
  FROM subscribers
  GROUP BY book_id
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- 3. Customers older than 30 years
SELECT * FROM customer
WHERE YEAR(CURDATE()) - YEAR(dob) > 30;

-- 4. Show subscribers who are not ACTIVE
SELECT * FROM subscribers
WHERE account_status != 'ACTIVE';

-- 5. Customers who haven't subscribed to any books
SELECT * FROM customer
WHERE customer_id NOT IN (
  SELECT customer_id FROM subscribers
);