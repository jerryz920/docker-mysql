
drop function if exists loopfunction;
delimiter //
create function loopfunction() returns int
begin     
  declare l_loop int default 0;    
  loop1: loop         
  set l_loop := l_loop + 1;         
  IF l_loop >= 100000 THEN           
    leave loop1;        
  end if;      
end loop loop1; 
return l_loop; 
end //

select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
select loopfunction(); //
