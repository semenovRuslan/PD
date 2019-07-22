
#even number of items. Median are average of neibords
select ISBN, avg(`Book-Rating`) as medianVal
from (
	select * ,
	FLOOR(allrec / 2) minavg , FLOOR(allrec / 2) + 1 maxavg
	from(
		select * ,
		max(rowindex) over (PARTITION BY ISBN) allrec
		from(
			select 
			ISBN, 
			`Book-Rating`,
			ROW_NUMBER() over(PARTITION BY ISBN order by `Book-Rating`) rowindex
			FROM bookstore.factrating
			) as f
		) as s
	where allrec / 2 = Floor(allrec / 2)
	) as c
where c.rowindex between minavg and maxavg
group by ISBN

union all

#Odd number of items. Median are number
    select ISBN
    , `Book-Rating` as medianVal 
	from(
    select * ,
		max(rowindex) over (PARTITION BY ISBN) allrec
		from(
			select 
			ISBN, 
			`Book-Rating`,
			ROW_NUMBER() over(PARTITION BY ISBN order by `Book-Rating`) rowindex
			FROM bookstore.factrating
			) as f
		) as s
	where allrec / 2 <> Floor(allrec / 2)
    and rowindex= Floor(allrec / 2) + 1




