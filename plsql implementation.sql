 

 

PLSQL Implementation 

Bashir Solomon | IS3S662 – Advanced Databases and Modelling | 18th February 2022 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

OVERVIEW 

This report aims to document the implementation of PL/SQL and the corresponding outputs. 

CREATE TABLES 

The following SQL code was used to create “books” and “book_copies” table in a database. 

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

The procedure checks for reasonable inputs, puts a new record in the “book” table and a corresponding new record in the “book_copies” table. 

 

CREATE OR REPLACE PROCEDURE add_book(  

    book_isbn IN VARCHAR2,  

    book_title IN VARCHAR2,  

    book_summary IN VARCHAR2,  

    book_author IN VARCHAR2,  

    book_date_published IN DATE,  

    book_page_count IN NUMBER,  

    bookcopy_barcode_id IN VARCHAR2  

)  

AS  

BEGIN  

    /* check for reasonable input */  

    IF book_isbn IS NULL THEN  

        RAISE VALUE_ERROR;  

    END IF;     

    /* insert a new record in book table */  

    INSERT INTO books(isbn, title, summary, author, date_published, page_count)  

    VALUES (book_isbn, book_title, book_summary, book_author, book_date_published, book_page_count);  

    /* insert a new record into book_copies table if barcode is provided */  

    IF bookcopy_barcode_id IS NOT NULL THEN  

        INSERT INTO book_copies(barcode_id, isbn)  

        VALUES (bookcopy_barcode_id,book_isbn);  

    END IF;  

END add_book;  

/ 

 

 

Test: Using the ‘add_book’ procedure to add records to the “book” table and corresponding records to the “book_copies” table. 

 

BEGIN    

    add_book(   

    '1-56592-335-9',   

    'Oracle PL/SQL Programming',   

    'Reference for PL/SQL developers, including examples and best practices recommendations.',   

    'Feuerstein Steven with Bill Pribyl',   

    TO_DATE('01-SEP-1997','DD-MON-YYYY'),   

    987,   

    '100000001'   

    );  

     

    add_book(   

    '0-14071-483-9',   

    'The tragedy of King Richard the Third',   

    'Modern publication of popular Shakespeare historical play in which a treacherous royal attempt to steal the crown but dies horseless in battle.',   

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

 

 

 

 

Using select statements to show book and corresponding book copy records. 

  

 

Adding more copies of an already existing book record to the book_copies table. 

INSERT INTO book_copies (isbn, barcode_id)   

VALUES ('1-56592-335-9', '100000002');  

  

INSERT INTO book_copies (isbn, barcode_id)   

VALUES ('0-14071-483-9', '100000016');  

  

INSERT INTO book_copies (isbn, barcode_id)   

VALUES ('1-56592-457-6', '100000022');   

  

INSERT INTO book_copies (isbn, barcode_id)   

VALUES ('1-56592-457-6', '100000020'); 

 

 

PROCEDURE THAT RETRIEVES BOOK COUNT  

This procedure retrieves the total number of copies a book has. 

CREATE OR REPLACE PROCEDURE book_count(  

    book_isbn IN book_copies.isbn%TYPE  

)  

AS  

total_copies number;   

BEGIN  

    SELECT COUNT(*) INTO total_copies   

    FROM book_copies  

    WHERE isbn = book_isbn;  

    DBMS_OUTPUT.PUT_LINE('Book count of ' || book_isbn || ' is: ' || total_copies);  

END book_count;  

/ 

 

Test: Using the ‘book_count’ procedure to output the number of copies books have. 

 

SET SERVEROUTPUT ON   

BEGIN  

    book_count('1-56592-335-9');  

    book_count('0-14071-483-9');  

    book_count('1-56592-457-6');       

END;  

/ 

 

 

 

 

 

 

 

 

 

 

PROCEDURE THAT GETS BOOK DETAILS 

This procedure accepts the isbn number of a book and returns the book’s title, author, date_published, and the number of copies. The main block calls the procedure with an isbn number and output the book’s details. 

CREATE PROCEDURE (P_BOOK_ID INTEGER)    CURSOR C1(L_BOOK_ID INTEGER) IS    SELECT * FROM COPIES WHERE BOOK_ID = L_BOOK_ID;    L_NUM_COPIES NUMBER;BEGIN    SELECT NO_OF_COPIES INTO L_NUM_COPIES FROM BOOK WHERE BOOK_ID = P_BOOK_ID;    IF L_NUM_COPIES>0        THEN            FOR CUR IN C1(P_BOOK_ID)            LOOP                DBMS_OUTPUT.PUT_LINE(CUR.COPY_NUMBER);            END LOOP;END; 

 

CREATE PROCEDURE (P_BOOK_ID INTEGER)    CURSOR C1(L_BOOK_ID INTEGER) IS    SELECT B.book_id,           B.shelf_letter,           B.call_number,           B.no_of_copies,           C.copy_id,           C.copy_number    FROM COPIES C,         BOOK B    WHERE C.BOOK_ID = L_BOOK_ID    AND C.BOOK_ID=B.BOOK_ID;    L_NUM_COPIES NUMBER;BEGIN    FOR CUR IN C1(P_BOOK_ID)    LOOP       DBMS_OUTPUT.PUT_LINE(CUR.book_id);          DBMS_OUTPUT.PUT_LINE(CUR.shelf_letter);       DBMS_OUTPUT.PUT_LINE(CUR.call_number);          DBMS_OUTPUT.PUT_LINE(CUR.no_of_copies);       DBMS_OUTPUT.PUT_LINE(CUR.copy_id);          DBMS_OUTPUT.PUT_LINE(CUR.copy_number);    END LOOP;END; 

CREATE OR REPLACE PROCEDURE getBookDetails( 

    book_isbn IN VARCHAR2  

)   

IS   

    book_title books.title%TYPE,   

    book_summary  books.summary%TYPE,   

    book_author  books.author%TYPE, 

    book_date_published  books.date_published%TYPE, 

    book_page_count  books.page_count%TYPE 

BEGIN 

    SELECT title, summary, author, date_published, page_count INTO 

    book_title, book_summary, book_author, book_date_published, book_page_count 

    FROM books 

    WHERE isbn = book_isbn; 

END getBookDetails; 

/ 

 

CREATE OR REPLACE PROCEDURE getBookDetails( 

    book_isbn IN VARCHAR2  

)   

IS 

    book_details books%ROWTYPE; 

    number_of_copies number;  

BEGIN 

    SELECT * INTO book_details FROM books 

    WHERE book_isbn = isbn; 

     

    SELECT COUNT(*) INTO number_of_copies FROM book_copies 

    WHERE book_isbn = isbn; 

END getBookDetails; 

/ 

 

create or replace NONEDITIONABLE PROCEDURE getBookDetails(  

    book_isbn IN VARCHAR2   

)    

IS  

    /* variable to store entire row of book records*/ 

    book_details books%ROWTYPE;  

    /* number of book copies variable*/ 

    number_of_copies number;   

BEGIN  

    /* put book details in variable*/ 

    SELECT * INTO book_details FROM books  

    WHERE book_isbn = isbn;     

    /* put number of book copies in variable*/ 

    SELECT COUNT(*) INTO number_of_copies FROM book_copies  

    WHERE book_isbn = isbn;  

END getBookDetails; 

/ 

PROCEDURE THAT PRINTS BOOK DETAILS 

This procedure utilises the getBookDetails procedure to print the data of each record. 

create OR replace FUNCTION get_book_id (  p_isbn            IN VARCHAR2, po_title          OUT VARCHAR2, po_no_of_copies   OUT NUMBER, po_call_number    OUT NUMBER, po_shelf_letter   OUT NUMBER)RETURN NUMBERIS  v_book_id NUMBER;BEGIN  BEGIN     SELECT         book_id      , title               , no_of_copies        , call_number         , shelf_letter      INTO         v_book_id      , po_title               , po_no_of_copies        , po_call_number         , po_shelf_letter      FROM book    WHERE isbn = 'p_isbn'    ;  EXCEPTION     WHEN NO_DATA_FOUND THEN    v_book_id := -1;  END;   RETURN v_book_id;END; 

PROCEDURE THAT DELETES BOOKS AND THEIR COPIES 

This procedure deletes a book and all their copies from the database. 

CREATE OR REPLACE PROCEDURE delete_book(   

book_isbn IN VARCHAR2 

) 

IS  

deleted_copies_count NUMBER; 

deleted_book_count NUMBER; 

BEGIN    

    /* delete record(s) from book copies table and keep track how many deleted*/  

    DELETE FROM book_copies WHERE isbn = book_isbn;  

    deleted_copies_count := SQL%ROWCOUNT; 

  

    /* delete record from book table and keep track of how many deleted */  

    DELETE FROM books WHERE isbn = book_isbn;  

    deleted_book_count := SQL%ROWCOUNT; 

 

    DBMS_OUTPUT.PUT_LINE(book_isbn || ': ' || deleted_book_count || ' book' || ' and ' || deleted_copies_count || ' book copies deleted');  

END delete_book;  

/ 

 

Test: Using the ‘delete_book’ procedure to delete book and all their copies from the database. 

 

SET SERVEROUTPUT ON 

BEGIN   

    delete_book('1-56592-335-9');      

    delete_book('0-14071-483-9');  

    delete_book('1-56592-457-6');  

END;   

/ 

TRIGGER THAT REPORTS NUMBER OF BOOK COPIES 

This trigger reports how many book copies are present after an insert, update or delete operation. 

 

CREATE OR REPLACE TRIGGER report_number_of_book_copies 

    AFTER INSERT OR UPDATE OR DELETE ON books 

    FOR EACH ROW 

DECLARE 

    current_count NUMBER; 

BEGIN 

    SELECT 1 INTO current_count FROM DUAL WHERE EXISTS ( 

        SELECT * FROM book_copies 

        WHERE book_copies.isbn = :new.isbn); 

        IF current_count = 0 

            THEN RAISE_APPLICATION_ERROR(-20001, 'The number of book copies is zero'); 

        END IF; 

        DBMS_OUTPUT.PUT_LINE(current_count || ' book copies remaining'); 

        EXCEPTION 

        WHEN NO_DATA_FOUND THEN 

            NULL; 

END; 

 

create or replace NONEDITIONABLE TRIGGER report_number_of_book_copies  

    AFTER INSERT OR UPDATE OR DELETE ON books 

    FOR EACH ROW  

DECLARE  

    current_count NUMBER;  

BEGIN  

    SELECT COUNT(*) INTO current_count FROM book_copies; 

    DBMS_OUTPUT.PUT_LINE(current_count || ' book copies present'); 

END; 

 

INSERT INTO books(isbn, title, summary, author, date_published, page_count)   

    VALUES ('r', 'book_title', 'book_summary', 'book_author', TO_DATE('01-APR-1999','DD-MON-YYYY'), 12); 

INSERT INTO book_copies(isbn,barcode_id) 

    VALUES ('r', '109'); 

     

UPDATE BOOKS SET TITLE = 'R' WHERE ISBN ='Q'; 

  

select * from book_copies; 

  

DELETE FROM book_COPIES WHERE BARCODE_ID = '10229'; 

  

SELECT * FROM BOOK_COPIES; 

  

create or replace NONEDITIONABLE TRIGGER report_number_of_book_copies 

  BEFORE INSERT OR UPDATE OR DELETE ON (books OR book_copies) 

  FOR EACH ROW 

DECLARE 

  current_count NUMBER; 

BEGIN 

  SELECT 1 INTO current_count FROM DUAL WHERE EXISTS ( 

    SELECT * FROM book_copies); 

    DBMS_OUTPUT.PUT_LINE( current_count || ' book copies present'); 

EXCEPTION 

  WHEN NO_DATA_FOUND THEN 

    NULL; 

END; 

/ 
