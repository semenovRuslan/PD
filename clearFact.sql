create temporary table table_insert(
select * from `bx-book-ratings`
);

# clear error in text field for join 
update table_insert
set ISBN = upper(RTRIM(LTRIM(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(ISBN, '[>".$:+,=#*_-]', ''), '&amp;', ''), '`', ''))));

#add new user 
insert into dimusers
(UserID, CityID, Location, Age)
select distinct `User-ID`, -9999, 'Unknown ' + `User-ID`, null
from table_insert sub
where not exists(select * from dimusers du where  (sub.`User-ID`=du.UserID));

#add  new book
insert into dimbooks
(ISBN, AuthorID, PublisherID, Title, `Year`) 
select distinct  ISBN, -9999, -9999, 'Unknown ', NULL 
from table_insert sub
where not exists( select * from dimbooks db where  (sub.ISBN=db.ISBN));


delete from FactRating;

insert into factrating
(UserID, ISBN, `Book-Rating`)
select du.UserID, db.ISBN, avg(sub.`Book-Rating`) from table_insert sub
left join dimusers du on (sub.`User-ID`=du.UserID)
left join dimbooks db on (sub.ISBN=db.ISBN)
group by  du.UserID, db.ISBN;