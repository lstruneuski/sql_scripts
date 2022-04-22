select dbms_lob.substr(s.sql_text,4000,1) sql_text,
   	   d.object_name,
   	   max(h.elapsed_time_total)/power(10,6) elapsed_time_total,
   	   max(h.disk_reads_total) disk_reads_total,
   	   max(h.buffer_gets_total) buffer_gets_total, count(1) cnt
from   dba_hist_sql_plan d,
   	   dba_hist_sqlstat  h,
   	   dba_hist_sqltext  s
where  d.object_owner = &owner
   	   and d.operation like 'TABLE ACCESS%'
   	   and d.options like '%FULL%'
   	   and d.sql_id = h.sql_id
   	   and s.sql_id = d.sql_id
   	   and d.timestamp> trunc(systimestamp)
group  by d.object_name,dbms_lob.substr(s.sql_text,4000,1)
order  by buffer_gets_total desc;

-------------------------------------------
select distinct sp.sql_id,s.sql_text,sp.operation,sp.options,sp.object_name,sp.filter_predicates,sp.access_predicates,s.executions
from  v$sql_plan sp,v$sql s
where options like '%FULL%' and object_owner= &owner
     	and sp.sql_id = s.sql_id(+)
order by s.executions desc,sp.sql_id;
