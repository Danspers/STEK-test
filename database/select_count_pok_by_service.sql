CREATE OR REPLACE FUNCTION stack.select_count_pok_by_service(_service integer, _date date)
RETURNS TABLE(acc integer, service integer, count bigint)
AS $$
BEGIN
    RETURN QUERY
    SELECT a.number, c.service, COUNT(mp.value)
    FROM stack.meter_pok AS mp
    LEFT JOIN stack.accounts as a ON mp.acc_id=a.row_id
    LEFT JOIN stack.counters as c ON mp.counter_id=c.row_id
    WHERE mp.date < _date
      AND mp.counter_id IN (SELECT row_id
                            FROM stack.counters
                            WHERE c.service=_service)
    GROUP BY a.number, c.service;
END;
$$ language plpgsql;