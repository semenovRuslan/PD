#1-st aproach (102.015 sec)
with cte_avgbook(ISBN, amount, cnt) as(
select ISBN
, sum(`Book-Rating`) as amount
, count(*) as cnt
from bookstore.factrating
group by ISBN
)
select ft.ISBN, cast(ft.amount/ft.cnt AS UNSIGNED) avgVal, Title 
from cte_avgbook  ft
left join bookstore.dimbooks dbook on (ft.ISBN=dbook.ISBN)
order by 2  desc;


#2 nd aproach - more quick (2.891 sec)
select ft.ISBN, cast(ft.amount/ft.cnt AS UNSIGNED) avgVal, Title
from (
select ISBN
, sum(`Book-Rating`) as amount
, count(*) as cnt
from bookstore.factrating
group by ISBN) as ft
left join bookstore.dimbooks dbook on (ft.ISBN=dbook.ISBN)
order by 2  desc;