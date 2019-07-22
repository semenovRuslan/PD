# PD

This review for consideration MySQL and Python opportunities for analyze data.
1.	Create table for DataWarehouse (scriptCreateTable.sql)
2.	Load data (BX-SQL-Dump.zip) scripts for load data into staging table
3.	Clear data (clearUsers.sql, clearFact.sql, clearBook.sql)
4.	Tasks show grouping data in database engine

Python was considered in 2 direction: 
1.	Data structure. Here I try to compare efficiency structure which was based on Dictionary and Array. This example – compare 2 library from python: array and dictionary.  
2.  Model review – Review data for estimation of quality of data. The idea is building model which can describe our information. Eventually model should be extended by addition information because quality of our model low for work in production. Model can be:
- improved on database stage(replace names of entities which often  doubled and differ because of additional word or wrong name)
- refuse from linear approach and move into non linear model. Random forest gives best result in regression. Can try neural network.
