  PROCEDURE rebuild_index(p_schema_name VARCHAR2,
                          p_index_name  VARCHAR2,
                          p_tablespace_name VARCHAR2 := NULL, -- Tablespace, if null - not change
                          p_rebuild_online INT := 0           -- rebuild online (1/0)
                         ) IS
    v_is_partitioned BOOLEAN := FALSE;
    v_is_subpartitioned BOOLEAN := FALSE;
    v_tablespace VARCHAR2(2000):= CASE WHEN p_tablespace_name IS NOT NULL
                                    THEN  ' tablespace '||p_tablespace_name
                                  END;
    v_rebuild_online VARCHAR2(2000) := CASE WHEN p_rebuild_online = 1
                                         THEN  ' online '
                                       END;
  BEGIN
    FOR rec IN (SELECT * FROM all_ind_subpartitions p
                WHERE p.index_owner = upper(p_schema_name) AND p.index_name = upper(p_index_name)
               )
    LOOP
      v_is_subpartitioned := TRUE;
      EXECUTE IMMEDIATE 'ALTER INDEX '||p_schema_name||'.'||p_index_name
                         ||' rebuild subpartition '||rec.subpartition_name||v_tablespace||v_rebuild_online;
    END LOOP;

    IF NOT v_is_subpartitioned THEN
      FOR rec IN (SELECT * FROM all_ind_partitions p
                  WHERE p.index_owner = upper(p_schema_name) AND p.index_name = upper(p_index_name)
                 )
      LOOP
        v_is_partitioned := TRUE;
        EXECUTE IMMEDIATE 'ALTER INDEX '||p_schema_name||'.'||p_index_name
                           ||' rebuild partition '||rec.partition_name||v_tablespace||v_rebuild_online;
      END LOOP;
    END IF;

    IF NOT v_is_partitioned AND NOT v_is_subpartitioned  THEN
      EXECUTE IMMEDIATE 'ALTER INDEX '||p_schema_name||'.'||p_index_name||' rebuild '||v_tablespace||v_rebuild_online;
    END IF;

  END rebuild_index;
