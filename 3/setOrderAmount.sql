-- NOTA: esta funcion supone que se
-- ha llamado a setPrize antes, o que
-- al menos, los campos price de orderdetail
-- estan bien

CREATE OR REPLACE VIEW ordersWithPrices as
		select orderid, sum(price) as total
		from orderdetail
		group by orderid;


CREATE OR REPLACE FUNCTION setOrderAmount () RETURNS void
	as $$
	declare
	BEGIN

        update
            orders as ORD
        set
            netamount=total,
            totalamount=total+tax
        from
            ordersWithPrices
        where ORD.orderid=ordersWithPrices.orderid;
    END;
    $$ LANGUAGE 'plpgsql';
