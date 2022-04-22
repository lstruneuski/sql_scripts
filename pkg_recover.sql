DECLARE 
   l_clob CLOB;
BEGIN
      dbms_lob.createtemporary (lob_loc => l_clob, 
                                cache   => true); 
  FOR s IN (SELECT s.text FROM dba_source AS OF TIMESTAMP sysdate-1/24  s  - an hour ago
            WHERE s.owner=&owner AND  s.name =&pkg_name AND s.type='PACKAGE BODY' 
            ORDER BY s.line
           )
LOOP
  dbms_lob.writeappend(lob_loc => l_clob,
                       amount  => length(s.text),
                       buffer  => s.text); 
END LOOP;
  :l_res :=l_clob; 
--dbms_output.put_line(l_clob); 
END;
