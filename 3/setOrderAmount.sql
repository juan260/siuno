-- Juan Riera y Luis Cárabe

-- Vista que contiene el identificador de una venta, 
-- y la cuantia economica de esa misma venta calculada
-- a partir de la suma de los precios de los articulos de la venta

-- NOTA: esta vista supone que se
-- ha llamado a setPrize antes, o que
-- al menos, los campos price de orderdetail
-- estan bien
CREATE OR REPLACE VIEW ordersWithPrices as
		select orderid, sum(price) as total
		from orderdetail
		group by orderid;

-- Funcion que tomando los precios de la view anterior, 
-- reajusta los precios de todas las ventas, es decir,
-- reajusta los campos netamount y totalamount

CREATE OR REPLACE FUNCTION setOrderAmount () RETURNS void
	as $$
	declare
	BEGIN

        update
            orders as ORD
        set
            netamount=total,
            totalamount=total*(1+(tax/100))
        from
            ordersWithPrices
        where ORD.orderid=ordersWithPrices.orderid;
    END;
    $$ LANGUAGE 'plpgsql';
