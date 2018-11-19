-- NOTA: esta funcion supone que se
-- ha llamado a setPrize antes, o que
-- al menos, los campos price de orderdetail
-- estan bien

-- NOTA 2: ESTA FUNCION ESTA SIN TERMINAR

CREATE OR REPLACE FUNCTION seOrderAmount () RETURNS void
	as $$
	declare
	BEGIN
        update
            orderdetail as DET
        set
            price=PROD.price/(power(1.02, 
                -- Current year
                    date_part('year', current_timestamp)
                    -
                -- Order year
                    extract(YEAR from orderdate)))
        from
            products as PROD,
            orders as ORD 
        where DET.prod_id=PROD.prod_id and
            ORD.orderid = DET.orderid;
    END;
    $$ LANGUAGE 'plpgsql';

