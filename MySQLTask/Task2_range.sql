		select *, 
		hight_bound - low_bound delta
        from
			(select 
			ISBN 
			, min(`Book-Rating`) low_bound
            , max(`Book-Rating`) hight_bound
            FROM bookstore.factrating
            group by ISBN
			) as f