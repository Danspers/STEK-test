WITH house_accounts AS (
    SELECT row_id, number
    FROM stack.accounts
    WHERE (type=3 AND parent_id IN (SELECT row_id
                                    FROM stack.accounts
                                    WHERE type = 1 AND number = 1))
       OR (type=3 AND parent_id IN (SELECT row_id
                                    FROM stack.accounts
                                    WHERE parent_id IN (SELECT row_id
                                                        FROM stack.accounts
                                                        WHERE type=1
                                                          AND number=1)))),
    monthly_pok AS (
    SELECT acc_id, counter_id, value
    FROM stack.meter_pok
    WHERE month='20230201')

SELECT ha.number AS acc, c.name, SUM(value)
FROM house_accounts AS ha
LEFT JOIN monthly_pok as mp ON ha.row_id=mp.acc_id
LEFT JOIN stack.counters as c ON mp.counter_id=c.row_id
GROUP BY ha.number, c.name;