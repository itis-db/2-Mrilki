/**
  @author Mrilki Denis Kim 11-305
 */
with cte AS (
    select * from consultant_pick_up_point where pointid < 5 and consultantid < 100
)select firstname, lastname, jobtitle, name
from cte join consultant on cte.consultantid = consultant.consultantid
         join pick_up_point on cte.pointid = pick_up_point.pointid;

select consultantid, pointid from consultant_pick_up_point
where consultantid > 30
union
select consultantid, pointid from consultant_pick_up_point
where pointid < 20;


with cte2 AS (
    select consultantid from consultant_pick_up_point
    union
    select pointid from consultant_pick_up_point
)
select consultant.consultantid, firstname, lastname from consultant, cte2 where consultant.consultantid > cte2.consultantid
union
select customersid, firstname, lastname from customers
