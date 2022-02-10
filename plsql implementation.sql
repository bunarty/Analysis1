 

 

PLSQL Implementation 

Bashir Solomon | IS3S662 – Advanced Databases and Modelling | 18th February 2022 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

OVERVIEW 

This report aims to document the implementation of PL/SQL and the corresponding outputs. 

CREATE TABLES 

The following SQL code was used to create books and book copies table in a database. 

CREATE TABLE books ( 

   isbn VARCHAR2(13) NOT NULL PRIMARY KEY, 

   title VARCHAR2(200), 

   summary VARCHAR2(2000), 

   author VARCHAR2(200), 

   date_published DATE, 

   page_count NUMBER 

); 

  

CREATE TABLE book_copies( 

   barcode_id VARCHAR2(100) NOT NULL PRIMARY KEY, 

   isbn VARCHAR2(13) REFERENCES books (isbn) 

); 

 

 

 

 

 

 

PROCEDURE THAT POPULATES TABLES 

The procedure checks for reasonable inputs, puts a new record in the book table and a corresponding new record in the book copies table 

CREATE OR REPLACE PROCEDURE add_book( 

    book_isbn IN VARCHAR2, 

    book_title IN VARCHAR2, 

    book_summary IN VARCHAR2, 

    book_author IN VARCHAR2, 

    book_date_published IN DATE, 

    book_page_count IN NUMBER, 

    bookcopy_barcode_id IN VARCHAR2 

) 

IS 

BEGIN 

    /* check for reasonable input */ 

    IF book_isbn IS NULL THEN 

        RAISE VALUE_ERROR; 

    END IF; 

     

    /* insert a new record in book table */ 

    INSERT INTO books(isbn, title, summary, author, date_published, page_count) 

    VALUES (book_isbn, book_title, book_summary, book_author, book_date_published, book_page_count); 

  

    /* insert a new record in book_copies table if barcode is provided */ 

    IF (bookcopy_barcode_id IS NOT NULL) THEN 

        INSERT INTO book_copies(barcode_id, isbn) 

        VALUES (bookcopy_barcode_id,book_isbn); 

    END IF; 

END add_book; 

/ 

 

Using ‘add_book’ procedure to add records to book and corresponding record book copies table. 

 

BEGIN  

add_book( 

    '1-56592-335-9', 

    'Oracle PL/SQL Programming', 

    'Reference for PL/SQL developers,'|| 

    'including examples and best practices recommendations.', 

    'Feuerstein Steven with Bill Pribyl', 

    TO_DATE('01-SEP-1997','DD-MON-YYYY'), 

    987, 

    '100000001' 

    );     

  

    add_book( 

    '0-14071-483-9', 

    'The tragedy of King Richard the Third', 

    'Modern publication of popular Shakespeare historical play in which a treacherous' 

    ||'royal attempt to steal the crown but dies horseless in battle.', 

    'William Shakespeare', 

    TO_DATE('01-AUG-2000','DD-MON-YYYY'), 

    158, 

    '100000015' 

    );  

    

    add_book( 

    '1-56592-457-6', 

    'Oracle PL/SQL Language Pocket Reference',  

    'Quick reference on Oracle’s PL/SQL language.',  

    'Feuerstein Steven with Bill Pribyl and Chip Dawes', 

    TO_DATE('01-APR-1999','DD-MON-YYYY'),  

    94,  

    '100000030' 

    );    

END;  

/ 

 

 Adds more copies of an existing book to the book_copies table database. 

 

INSERT INTO BOOK_COPIES (ISBN, BARCODE_ID)  

VALUES ('1-56592-335-9', '100000002'); 

 

INSERT INTO BOOK_COPIES (ISBN, BARCODE_ID)  

VALUES ('0-14071-483-9', '100000016'); 

 

INSERT INTO BOOK_COPIES (ISBN, BARCODE_ID)  

VALUES ('1-56592-457-6', '100000022'); 

 

INSERT INTO BOOK_COPIES (ISBN, BARCODE_ID)  

VALUES ('1-56592-457-6', '100000020'); 

 

 

 

Page Break
 

 

PROCEDURE THAT RETRIEVES BOOK COUNT  

This procedure retrieves the total number of copies a book has. 

 

CREATE OR REPLACE PROCEDURE book_count( 

    book_isbn IN book_copies.isbn%TYPE 

) 

IS 

 

total_copies number; 

  

BEGIN 

    SELECT COUNT(*) INTO total_copies  

    FROM book_copies 

    WHERE isbn = book_isbn; 

    DBMS_OUTPUT.PUT_LINE(book_isbn || 'book count is:'|| total_copies); 

END book_count; 

 

Testing book count procedure 

 
SET SERVEROUTPUT ON 

  

BEGIN 

book_count('1-56592-335-9'); 

book_count('0-14071-483-9'); 

book_count('1-56592-457-6');      

END; 

/ 

 

 

 

PROCEDURE THAT GETS BOOK DETAILS 

This procedure accepts the isbn number of a book and returns the book’s title, author, date_published, and the number of copies. The main block calls the procedure with an isbn number and output the book’s details. 

 

PROCEDURE THAT PRINTS BOOK DETAILS 

This procedure utilises the getBookDetails procedure to print the data of each record. 

PROCEDURE THAT DELETES BOOKS AND THEIR COPIES 

This procedure deletes a book and all their copies from the database. 

 

PROCEDURE remove_books (  

date_in IN DATE,  

removal_count_out OUT PLS_INTEGER)  

IS  

BEGIN  

DELETE FROM books WHERE date_published < date_in;  

removal_count_out := SQL%ROWCOUNT;  

END;  

 

CREATE OR REPLACE PROCEDURE PRC_DeleteProd(x IN INTEGER)AS    v_dcode    distributor.d_code%type;    v_gcode    goods.g_code%type;    v_gcode2   line.g_code%type; CURSOR v_delete_cursor IS   SELECT goods.g_code, line.g_code , d_code     FROM distributor     JOIN goods ON (distributor.d_code = goods.g_code)     JOIN line ON (goods.g_code = line.g_code);BEGIN  OPEN v_delete_cursor;  LOOP    FETCH v_delete_cursor INTO v_dcode, v_gcode, v_gcode2;    EXIT WHEN v_cus_cursor%NOTFOUND;    IF x = v_dcode THEN      DELETE FROM line WHERE v_gcode2 = x;      DELETE FROM goods WHERE v_gcode = x;    END IF;  END LOOP;END;/ 

TRIGGER THAT REPORTS NUMBER OF BOOK COPIES 

This trigger reports how many book copies are present after an insert, update or delete operation. 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 
