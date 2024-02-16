CREATE OR REPLACE FUNCTION stack.select_last_pok_by_acc(_acc int)
RETURNS TABLE(acc integer, service integer, date date, tarif integer, value integer)
AS $$
BEGIN
    RETURN QUERY
    WITH acc_pok AS (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY mp.counter_id, mp.tarif ORDER BY mp.date DESC) AS row_num
        FROM stack.meter_pok AS mp
        LEFT JOIN stack.accounts AS acc ON mp.acc_id=acc.row_id
        WHERE acc.type=3 AND acc.number=_acc)
    
    SELECT ap.number, c.service, ap.date, ap.tarif, ap.value
    FROM acc_pok AS ap
    LEFT JOIN stack.counters as c ON ap.counter_id=c.row_id
    WHERE ap.row_num=1;
END;
$$ language plpgsql;