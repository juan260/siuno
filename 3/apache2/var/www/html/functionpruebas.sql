CREATE OR REPLACE FUNCTION foo (integer) RETURNS integer
	as $$
	declare
	begin
		return $1;
	end;
	$$ LANGUAGE 'plpgsql';

select foo(3);
