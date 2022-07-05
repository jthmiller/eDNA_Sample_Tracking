### sql queries


dbExecute(conn,sql)



dbExecute(conn, "UPDATE filtersdb SET new_col = :new_col where year = :year",
          params=data.frame(new_col=new_values,
                            year=cars$year))



collections_updates <- c('Collected_date', 'Extracted_date', 'Filtered_Date', 'Cut_in_half', 'modified_at', 'modified_by')


collections_updates <- c(
'UPDATE filtersdb
SET
      Collected_date = (SELECT temp_batch.Collected_date
                            FROM temp_batch
                            WHERE temp_batch.uid = filtersdb.uid )
WHERE
    EXISTS (
        SELECT *
        FROM temp_batch
        WHERE temp_batch.uid = filtersdb.uid
    )',
'UPDATE filtersdb
SET
      Extracted_date = (SELECT temp_batch.Extracted_date
                            FROM temp_batch
                            WHERE temp_batch.uid = filtersdb.uid )
WHERE
    EXISTS (
        SELECT *
        FROM temp_batch
        WHERE temp_batch.uid = filtersdb.uid
    )',
'UPDATE filtersdb
SET
      Filtered_Date = (SELECT temp_batch.Filtered_Date
                            FROM temp_batch
                            WHERE temp_batch.uid = filtersdb.uid )
WHERE
    EXISTS (
        SELECT *
        FROM temp_batch
        WHERE temp_batch.uid = filtersdb.uid
    )',
'UPDATE filtersdb
SET
      Cut_in_half = (SELECT temp_batch.Cut_in_half
                            FROM temp_batch
                            WHERE temp_batch.uid = filtersdb.uid )
WHERE
    EXISTS (
        SELECT *
        FROM temp_batch
        WHERE temp_batch.uid = filtersdb.uid
    )',
'UPDATE filtersdb
SET
      modified_at = (SELECT temp_batch.modified_at
                            FROM temp_batch
                            WHERE temp_batch.uid = filtersdb.uid )
WHERE
    EXISTS (
        SELECT *
        FROM temp_batch
        WHERE temp_batch.uid = filtersdb.uid
    )',
'UPDATE filtersdb
SET
      modified_by = (SELECT temp_batch.modified_by
                            FROM temp_batch
                            WHERE temp_batch.uid = filtersdb.uid )
WHERE
    EXISTS (
        SELECT *
        FROM temp_batch
        WHERE temp_batch.uid = filtersdb.uid
    )')


