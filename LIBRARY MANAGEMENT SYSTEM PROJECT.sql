                      -- SQL PROJECT --
			 --   LIBRARY MANAGEMENT SYSTEM 	 --

CREATE DATABASE LIBRARY;
USE LIBRARY;

-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);

SELECT * FROM TBL_BOOK;
SELECT * FROM TBL_BOOK_AUTHORS;
SELECT * FROM tbl_book_copies;
SELECT * FROM TBL_BOOK_LOANS;
SELECT * FROM TBL_BORROWER;
SELECT * FROM TBL_LIBRARY_BRANCH;
SELECT * FROM TBL_PUBLISHER;

--  1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT  BT.BOOK_TITLE, TL.LIBRARY_BRANCH_BRANCHNAME, LB.book_copies_No_Of_Copies 
FROM TBL_BOOK BT
JOIN TBL_BOOK_COPIES LB  ON
BT.book_BookID = LB.book_copies_BookID
JOIN TBL_LIBRARY_BRANCH TL ON
TL.library_branch_BranchID = LB.book_copies_BranchID
WHERE BT.BOOK_TITLE = "THE LOST TRIBE" AND TL.LIBRARY_BRANCH_BRANCHNAME = "SHARPSTOWN";

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT  TL.LIBRARY_BRANCH_BRANCHNAME,
sum(BOOK_COPIES_NO_OF_COPIES) AS TOTAL
FROM TBL_BOOK BT
JOIN TBL_BOOK_COPIES LB  ON
BT.book_BookID = LB.book_copies_BookID
JOIN TBL_LIBRARY_BRANCH TL ON
TL.library_branch_BranchID = LB.book_copies_BranchID
WHERE BT.BOOK_TITLE = "THE LOST TRIBE" 
GROUP BY TL.LIBRARY_BRANCH_BRANCHNAME;

-- 3. Retrieve the names of all borrowers who do not have any books checked out.

SELECT A.BORROWER_BORROWERNAME FROM tbl_borrower A LEFT JOIN tbl_book_loans B ON
A.borrower_CardNo =B.book_loans_CardNo 
WHERE B.BOOK_LOANS_CARDNO IS NULL;

-- 4. For each book that is loaned out from the "Sharpstown" branch and 
-- whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
 
SELECT BT.BOOK_TITLE, TB.BORROWER_BORROWERNAME, TB.BORROWER_BORROWERADDRESS
FROM TBL_BOOK BT
JOIN TBL_BOOK_LOANS TBL ON
BT.book_BookID = TBL.BOOK_LOANS_BOOKID
JOIN TBL_BORROWER TB ON
TB.BORROWER_CARDNO = TBL.book_loans_CardNo
JOIN TBL_LIBRARY_BRANCH TLB ON
TLB.LIBRARY_BRANCH_BRANCHID = TBL.BOOK_LOANS_BRANCHID
WHERE TLB.LIBRARY_BRANCH_BRANCHNAME = "SHARPSTOWN" AND TBL.BOOK_LOANS_DUEDATE = "2/3/18";

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT LIBRARY_BRANCH_BRANCHNAME AS BRANCH_NAME,
COUNT(book_loans_BranchID) AS TOTAL_NUMBER_OF_BOOKS_LOANED
FROM tbl_library_branch
JOIN tbl_book_loans ON
library_branch_BranchID = book_loans_BranchID
GROUP BY LIBRARY_BRANCH_BRANCHNAME;

-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out

SELECT BORROWER_BORROWERNAME AS BORROWERS, BORROWER_BORROWERADDRESS AS ADDRESS, 
COUNT(BOOK_LOANS_BOOKID) AS TOTAL
FROM tbl_borrower 
JOIN tbl_book_loans ON
borrower_CardNo = book_loans_CardNo
GROUP BY BORROWER_BORROWERNAME, BORROWER_BORROWERADDRESS
HAVING TOTAL > 5 ;

-- 7. For each book authored by "Stephen King", 
-- retrieve the title and the number of copies owned by the library branch whose name is "Central"

SELECT TB.book_Title AS TITLE, SUM(book_copies_No_Of_Copies) AS TOTAL
FROM tbl_book TB
JOIN tbl_book_authors TBA ON
TB.book_BookID = TBA.book_authors_BookID
JOIN tbl_book_copies TBC ON
TB.book_BookID = TBC.book_copies_BookID
JOIN tbl_library_branch TLB ON
TBC.book_copies_BranchID = TLB.library_branch_BranchID
WHERE TBA.book_authors_AuthorName = "Stephen King" AND
TLB.library_branch_BranchName = "CENTRAL"
GROUP BY TB.BOOK_TITLE;








