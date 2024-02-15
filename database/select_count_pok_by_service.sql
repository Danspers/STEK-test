-- №№ л/с квартир и row_id (внешний ключ)
--SELECT row_id, number AS acc FROM stack.accounts WHERE type = 3;

SELECT accounts.number AS acc, service, COUNT(meter.value)
FROM stack.meter_pok AS meter
LEFT JOIN stack.accounts as accounts ON meter.acc_id = accounts.row_id
LEFT JOIN stack.counters as counters ON meter.counter_id = counters.row_id
WHERE date < '20230201'
  AND counter_id IN (SELECT row_id
                     FROM stack.counters
                     WHERE service = 300)
GROUP BY acc, service;