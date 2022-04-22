select 'alter table '||c.table_name||'  enable constraint  '||c.constraint_name||';' 
from user_constraints c
where c.constraint_type = 'R'
