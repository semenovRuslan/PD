CREATE TEMPORARY TABLE IF NOT EXISTS table_correctbook AS (
        select ISBN,`Book-Title`,`Book-Author`,`Year-Of-Publication`, Publisher
        from bookstore.`bx-books`);
        
        # clear error in text field for join 
        update table_correctbook
        set ISBN = upper(RTRIM(LTRIM(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(ISBN, '[>".$:+,=#*_-]', ''), '&amp;', ''), '`', '')))) 
        , Publisher =upper(RTRIM(LTRIM(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(Publisher, '[>".$:+,=#*_-]', ''), '&amp;', ''), '`', ''))))
        , `Book-Author` = upper(RTRIM(LTRIM(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(`Book-Author`, '[>".$:+,=#*_-]', ''), '&amp;', ''), '`', '')))) ;
          
        insert into dimpublisher(PublisherName)
        select distinct Publisher from table_correctbook
        where not exists(select * from dimpublisher sub where sub.PublisherName=table_correctbook.Publisher);
        
        insert into dimauthor(AuthorName)
        select distinct `Book-Author`
        from table_correctbook
		where not exists(select * from dimauthor sub where sub.AuthorName=table_correctbook.`Book-Author`);
        
        
        INSERT INTO bookstore.dimbooks (ISBN, AuthorID, PublisherID, Title, `Year`) 
        select sub.ISBN, da.AuthorID, dp.PublisherID, sub.`Book-Title`, sub.`Year-Of-Publication` from table_correctbook as sub
        left join dimauthor da on (da.AuthorName = sub.`Book-Author`)
        left join dimpublisher dp on (dp.PublisherName = sub.Publisher)
		ON DUPLICATE KEY UPDATE AuthorID=da.AuthorID, PublisherID=dp.PublisherID, Title=sub.`Book-Title`, `Year`=sub.`Year-Of-Publication`;
        