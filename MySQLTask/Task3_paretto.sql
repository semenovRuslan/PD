select *
from (
    select *
    , row_number() over()/allusers as `%users`
    , addsum/allballs as `%balls`	
    from(
        select *
        , count(*) over () allusers
        , sum(ball) over () allballs
        , sum(ball) over (order by ball desc rows  UNBOUNDED PRECEDING) addsum
		from
            (select 
			UserID 
			, sum(`Book-Rating`) ball
            FROM bookstore.factrating
            group by UserID
			) as f
            order by 2 desc
		) as c
	) as resl
	where `%users` <= 0.2
	