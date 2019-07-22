	#rank remain all lider value. 	
	select * 
      from  (
      select *
        , row_number() over (partition by ISBN order by num_users desc) popularity
        from
            (select 
			ISBN , 
			`Book-Rating`,
            count(UserID) num_users
			FROM bookstore.factrating
            group by ISBN, 
			`Book-Rating`
			) as f
            ) as c
	where popularity = 1 
	order by 1, 4