with cte_user(UserID, countActivities) as(
select UserID, 
count(*) AS countActivities
from bookstore.factrating
group by UserID)
select count(*) from cte_user ft
where countActivities=2;
