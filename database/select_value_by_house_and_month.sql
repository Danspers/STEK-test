CREATE OR REPLACE FUNCTION stack.select_value_by_house_and_month(_house int, _date date)
RETURNS TABLE(acc integer, name text, value bigint)
AS $$
BEGIN
    RETURN QUERY
    WITH house_accounts AS (
        SELECT row_id, number
        FROM stack.accounts
        WHERE (type=3 AND parent_id IN (SELECT row_id
                                        FROM stack.accounts
                                        WHERE type=1 AND number=_house))
           OR (type=3 AND parent_id IN (SELECT row_id
                                        FROM stack.accounts
                                        WHERE parent_id IN (SELECT row_id
                                                            FROM stack.accounts
                                                            WHERE type=1 AND number=_house)))),
        monthly_pok AS (
        SELECT acc_id, counter_id, meter_pok.value
        FROM stack.meter_pok
        WHERE month=_date)

    SELECT ha.number, c.name, SUM(mp.value)
    FROM house_accounts AS ha
    LEFT JOIN monthly_pok as mp ON ha.row_id=mp.acc_id
    LEFT JOIN stack.counters as c ON mp.counter_id=c.row_id
    GROUP BY ha.number, c.name;
END;
$$ language plpgsql;