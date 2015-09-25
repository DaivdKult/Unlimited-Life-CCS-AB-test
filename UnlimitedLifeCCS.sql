-- 2014-12-01: Unlimited Life CCS AB-test 

-- For players in the test: when they started and which group they belong to

drop table davidk.abtestulife; 
create table davidk.abtestulife as
select a.coreuserid,a.flavourid, a.casenum, MIN(a.msts) as firsttimeintest, MIN(a.dt) as firstday
from doughnut.f_social_ab_tests a
where a.ABTESTNAME='ccsm_unlimited_life_campaign_final' and a.abtestversion=7 and a.coreuserid is not NULL and a.dt>='2014-11-28' and a.dt<='2014-11-30'
group by a.coreuserid,a.flavourid, a.casenum;


--Calculating general KPI's split between test groups

drop table davidk.abulactivity;
create table davidk.abulactivity as
select b.dt, a.casenum, b.kingappid,COUNT(distinct a.coreuserid) as players, SUM(b.spend_usd) as gb, 
SUM(b.num_game_end) as gameends, SUM(b.num_message_sent) as messages 
from davidk.abtestulife a
JOIN doughnut.f_activity_summary b on (a.coreuserid=b.coreuserid)
where b.dt>=a.firstday and b.dt>='2014-11-28' 
group by b.dt, a.casenum, b.kingappid;


--Calculating retention split between test groups

drop table davidk.abulretention;
create table davidk.abulretention as
select a.firstday, b.dt, a.casenum, COUNT(distinct a.coreuserid) as players, SUM(b.spend_usd)
from davidk.abtestulife a
JOIN doughnut.f_activity_summary b on (a.coreuserid=b.coreuserid)
where b.dt>=a.firstday and b.kingappid=17 and b.dt>='2014-11-07'
group by a.firstday, b.dt, a.casenum;



drop table davidk.valuebef;
create table davidk.valuebef as
select a.casenum, SUM(b.spend_usd) as gb
from davidk.abtestulife a 
JOIN doughnut.f_activity_summary b on (a.coreuserid=b.coreuserid)
where b.dt>='2014-10-07' and b.dt>=date_add(a.firstday,-30) and b.dt<a.firstday
group by a.casenum;
