		CREATE TEMPORARY TABLE IF NOT EXISTS table_correct AS (
        select *
        from
			(
			select 
			@num_street_lines := 1 + LENGTH(Location) - LENGTH(REPLACE(Location, ',', '')) AS num_street_lines ,
			`User-ID`, Location, Age
			, substring_index(location, ',', 1) city
			, if(@num_street_lines>1, substring_index(substring_index(location, ',', 2), ',', -1), '') state
			, if(@num_street_lines>2, substring_index(substring_index(location, ',', 3), ',', -1), '') country
			from bookstore.`bx-users`
            ) as f
		where num_street_lines=3
        );
        
        
        CREATE TEMPORARY TABLE IF NOT EXISTS table_mistakesLessData AS (
        select *
        from
			(
			select 
			@num_street_lines := 1 + LENGTH(Location) - LENGTH(REPLACE(Location, ',', '')) AS num_street_lines ,
			`User-ID`, Location, Age
			, substring_index(location, ',', 1) city
			, if(@num_street_lines>1, substring_index(substring_index(location, ',', 2), ',', -1), '') state
			, if(@num_street_lines>2, substring_index(substring_index(location, ',', 3), ',', -1), '') country
			from bookstore.`bx-users`
            ) as f
		where num_street_lines<3
        );
        
        CREATE TEMPORARY TABLE IF NOT EXISTS table_mistakesMoreData AS (
        select *
        from
			(
			select 
			@num_street_lines := 1 + LENGTH(Location) - LENGTH(REPLACE(Location, ',', '')) AS num_street_lines ,
			`User-ID`, Location, Age
			, substring_index(location, ',', @num_street_lines-2) city
			, if(@num_street_lines>1, substring_index(substring_index(location, ',', @num_street_lines - 1), ',', -1), '') state
			, if(@num_street_lines>2, substring_index(substring_index(location, ',', @num_street_lines), ',', -1), '') country
			from bookstore.`bx-users`
            ) as f
		where num_street_lines>3
        );
        
        
        CREATE TEMPORARY TABLE IF NOT EXISTS table_correctsource AS (select * from table_correct);
        
        #if less we use usual deviding and try to restore unused
        # just country:
        update table_mistakesLessData
        set country = (select  country from table_correctsource f 
        where f.city = table_mistakesLessData.city
        and f.state =  table_mistakesLessData.state limit 0, 1)
        , num_street_lines=3
        where num_street_lines between 1 and 2
        and exists(
        select * from table_correct sub 
        where sub.city = table_mistakesLessData.city
        and sub.state =  table_mistakesLessData.state
        )
        ;
        # 2. country and state
        update table_mistakesLessData
        set state = (select  state from table_correctsource f 
        where f.city = table_mistakesLessData.city
		limit 0, 1)
        where num_street_lines between 1 and 2
        and exists(
        select * from table_correct sub 
        where sub.city = table_mistakesLessData.city
        )
        ;
        # 2. country
		update table_mistakesLessData
        set country = (select  country from table_correctsource f 
        where f.city = table_mistakesLessData.city
        and f.state =  table_mistakesLessData.state limit 0, 1)
        , num_street_lines=3
        where num_street_lines between 1 and 2
        and exists(
        select * from table_correct sub 
        where sub.city = table_mistakesLessData.city
        and sub.state =  table_mistakesLessData.state
        );
        
        #insert into correct data from mistakes if match was found 
        insert into table_correct
        (`User-ID`, Location, Age, city, state, country)
        select `User-ID`, Location, Age, city, state, country from table_mistakesLessData where num_street_lines=3;
        delete from table_mistakesLessData where num_street_lines=3;
        
        
        
        
        #considering row where rows more than 3 
        #we should understand that rows have correct rows in country and state
        #mark this sort of row "num_street_lines=3"
		update  table_mistakesMoreData 
        set  num_street_lines=3
        where num_street_lines>3
        and exists(
        select * from table_correctsource sub 
        where sub.country = table_mistakesMoreData.country
        and sub.state = table_mistakesMoreData.state
        );
		#mistake in countryname 
		update  table_mistakesMoreData 
        set country= (select  country from table_correct f 
        where f.state =  table_mistakesMoreData.state limit 0, 1)
        , num_street_lines=3
        where num_street_lines>3
        and exists(
        select * from table_correctsource sub 
        where sub.state = table_mistakesMoreData.state
        );
		#we should understand that rows have correct rows in country
        update  table_mistakesMoreData 
        set  num_street_lines=3
        , state='n.a.'
        where num_street_lines>3
        and exists(
        select * from table_correctsource sub 
        where sub.country = table_mistakesMoreData.country
        );
        
      	#insert into correct data from mistakes if match was found 
        insert into table_correct
        (`User-ID`, Location, Age, city, state, country)
        select  `User-ID`, Location, Age, city, state, country  from table_mistakesMoreData
        where num_street_lines=3;
		delete from table_mistakesMoreData 
		where  num_street_lines=3;
       
        insert into table_correct
        (`User-ID`, Location, Age, city, state, country)
        select `User-ID`, Location, Age, 'na' city, 'na' state, 'na' country from table_mistakesMoreData;
        
        
        
        
        ##select distinct trim(country)#, preg_replace("/[^0-9]/","",country)  
        update table_correct
        set country= trim(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(country, '[0-9]+', ''), '[-*;.,!?{#&]', ''), '[äå½±ãâ©ð¹¸­_><º]', ''))
        , State=trim(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(State, '[0-9]+', ''), '[-*;.,!?{#&]', ''), '[äå½±ãâ©ð¹¸­_><º]', ''))
        , City=trim(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(City, '[0-9]+', ''), '[-*;.,!?{#&]', ''), '[äå½±ãâ©ð¹¸­_><º]', ''))
;
# mark unknown
        update table_correct set country= 'na' where length(country)=0;
        update table_correct set State= 'na' where length(State)=0;
        update table_correct set City= 'na' where length(City)=0;
      ;


		CREATE TEMPORARY TABLE IF NOT EXISTS table_insert AS (select `user-id`, Location, Age, city, -9999 cityID, state, -9999 stateID, country, -9999 countryID  from table_correct);

		#Add new country 
        INSERT INTO bookstore.dimcountry (CountryName)
        select distinct country from table_insert
        where not exists(select * from bookstore.dimcountry sub where sub.CountryName=table_insert.country);
		
        update table_insert
        set countryID = coalesce((select sub.CountryID from bookstore.dimcountry sub where sub.CountryName=table_insert.country limit 0, 1), -9999);
        
        #Add new state 
        INSERT INTO bookstore.dimstate (StateName, CountryID)
        select distinct State, countryID  
        from table_insert temp
        where not exists(select * from bookstore.dimstate sub where sub.StateName=temp.state and sub.CountryID=temp.countryID) 
        ;
       
        update table_insert
        set stateID = coalesce((select sub.stateID from bookstore.dimstate sub where sub.StateName=table_insert.State and sub.CountryID=table_insert.countryid limit 0, 1), -9999);
        
		
        #Add new city 
        INSERT INTO bookstore.dimcity(CityName, StateID)
        select distinct city, stateid  
        from table_insert temp
        where not exists(select * from bookstore.dimcity sub where sub.cityName=temp.city and sub.StateID=temp.stateid)
        ;
         
		update table_insert
        set cityID = coalesce((select sub.cityID from bookstore.dimcity sub where sub.CityName=table_insert.city and sub.stateID=table_insert.stateid limit 0, 1), -9999);
      
        #merge (update/insert) Dimension Table
		INSERT INTO bookstore.dimusers (UserID, Location, Age, CityID) 
        select f.`User-ID`, f.Location, f.Age,  f.CityID from table_insert f
		ON DUPLICATE KEY UPDATE Location=f.Location, Age=f.Age, CityID=f.cityID;
        
        