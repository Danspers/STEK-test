CREATE OR REPLACE FUNCTION stack.select_count_pok_by_service(_service int, _date date)
RETURNS TABLE(acc integer, service integer, count bigint)
AS $$
BEGIN
    RETURN QUERY
    SELECT accounts.number AS acc,
           counters.service,
           COUNT(meter.value)
    FROM stack.meter_pok AS meter
    LEFT JOIN stack.accounts as accounts ON meter.acc_id = accounts.row_id
    LEFT JOIN stack.counters as counters ON meter.counter_id = counters.row_id
    WHERE meter.date < _date
      AND meter.counter_id IN (SELECT row_id
                               FROM stack.counters
                               WHERE counters.service = _service)
    GROUP BY accounts.number, counters.service;
END;
$$ language plpgsql;