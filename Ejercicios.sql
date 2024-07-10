#Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

select codigo_oficina, ciudad from oficina;

#Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

select ciudad, telefono from oficina where pais="España";

#Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

select nombre, apellido1,apellido2,email from empleado where codigo_jefe=7;

#Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

select puesto, nombre, apellido1, apellido2, email from empleado where puesto="Director General";

#Devuelve un listado con el nombre, apellidos y puesto de aquellos
#empleados que no sean representantes de ventas.

select nombre, apellido1, apellido2, puesto from empleado where puesto!="Representante Ventas";

#Devuelve un listado con el nombre de los todos los clientes españoles.

select nombre_cliente from cliente where pais="Spain";

#Devuelve un listado con los distintos estados por los que puede pasar un pedido.

select distinct estado from pedido;

#Devuelve un listado con el código de cliente de aquellos clientes que
#realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
#aquellos códigos de cliente que aparezcan repetidos.

select distinct cl.codigo_cliente from cliente cl
join pedido pe on cl.codigo_cliente=pe.codigo_cliente
where year(fecha_pedido)=2008;

select distinct cl.codigo_cliente from cliente cl
join pedido pe on cl.codigo_cliente=pe.codigo_cliente
where date_format(fecha_pedido,'%Y')=2008;

select distinct cl.codigo_cliente from cliente cl
join pedido pe on cl.codigo_cliente=pe.codigo_cliente
where left(fecha_pedido,4)="2008";

#Devuelve un listado con el código de pedido, código de cliente, fecha
#esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.

select distinct codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega from pedido

where fecha_entrega>fecha_esperada;

#Devuelve un listado con el código de pedido, código de cliente, fecha
#esperada y fecha de entrega de los pedidos cuya fecha de entrega ha
#sido al menos dos días antes de la fecha esperada.
#● Utilizando la función ADDDATE de MySQL.
#● Utilizando la función DATEDIFF de MySQL.

select distinct codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega from pedido 
where datediff(fecha_esperada, fecha_entrega) >= 2;

select distinct codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega from pedido 
where date_add(fecha_esperada, interval 2 day) <= fecha_entrega;

#Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

select * from pedido where estado="Rechazado" and year(fecha_pedido)=2009;

#Devuelve un listado de todos los pedidos que han sido entregados en el
#mes de enero de cualquier año.

select * from pedido where estado="Entregado" and month(fecha_entrega)=01;

#Devuelve un listado con todos los pagos que se realizaron en el año 2008
#mediante Paypal. Ordene el resultado de mayor a menor.

select * from pago where forma_pago="PayPal" and year(fecha_pago)=2008
order by total desc;

#Devuelve un listado con todas las formas de pago que aparecen en la
#tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.

select distinct forma_pago from pago;

#Devuelve un listado con todos los productos que pertenecen a la gama
#Ornamentales y que tienen más de 100 unidades en stock. El listado deberá
#estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.

select * from producto where gama="Ornamentales" and cantidad_en_stock>100
order by precio_venta desc;

#Devuelve un listado con todos los clientes que sean de la ciudad de
#Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.

select * from cliente where ciudad="Madrid" and (codigo_empleado_rep_ventas=11 or codigo_empleado_rep_ventas=30);

#========================================================================================================================================================================
#Consultas multitabla (Composición interna)

#Obtén un listado con el nombre de cada cliente y el nombre y apellido
#de su representante de ventas.

select nombre_cliente, nombre as Nombre_Representante,apellido1 as Apellido_Representante from cliente cl 
join empleado em on cl.codigo_empleado_rep_ventas=em.codigo_empleado;

#Muestra el nombre de los clientes que hayan realizado pagos junto con
#el nombre de sus representantes de ventas.

select nombre_cliente, nombre as Nombre_Representante from cliente cl 
join empleado em on cl.codigo_empleado_rep_ventas=em.codigo_empleado
join pago pg on pg.codigo_cliente=cl.codigo_cliente 
where fecha_pago<now();

SELECT 
    cliente.nombre_cliente,
    CONCAT(empleado.nombre, ' ', empleado.apellido1, ' ', COALESCE(empleado.apellido2, '')) AS nombre_representante_ventas
FROM 
    pago
JOIN 
    cliente ON pago.codigo_cliente = cliente.codigo_cliente
LEFT JOIN 
    empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

#Muestra el nombre de los clientes que no hayan realizado pagos junto
#con el nombre de sus representantes de ventas.

select nombre_cliente from cliente cl 
left join pago pg on pg.codigo_cliente=cl.codigo_cliente
left join empleado em on cl.codigo_empleado_rep_ventas=em.codigo_empleado
where pg.codigo_cliente is null;

#Devuelve el nombre de los clientes que han hecho pagos y el nombre de
#sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

select cl.nombre_cliente, em.nombre, ofi.ciudad from cliente cl 
join pago pg on pg.codigo_cliente=cl.codigo_cliente
join empleado em on cl.codigo_empleado_rep_ventas=em.codigo_empleado
join oficina ofi on ofi.ciudad=cl.ciudad;

#Devuelve el nombre de los clientes que no hayan hecho pagos y el
#nombre de sus representantes junto con la ciudad de la oficina a la que
#pertenece el representante.

select cl.nombre_cliente, em.nombre, ofi.ciudad,pg.* from cliente cl
left join pago pg on pg.codigo_cliente=cl.codigo_cliente
join empleado em on cl.codigo_empleado_rep_ventas=em.codigo_empleado
join oficina ofi on ofi.ciudad=cl.ciudad
where pg.codigo_cliente is null;

#Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.

select ofi.linea_direccion1 from oficina ofi
join cliente cl on cl.region=ofi.region
where cl.ciudad="Fuenlabrada";

#Devuelve el nombre de los clientes y el nombre de sus representantes
#junto con la ciudad de la oficina a la que pertenece el representante.

select cl.nombre_cliente as Nomb_Cliente, em.nombre as Nomb_Representante,ofi.ciudad as Nombre_Ciudad from cliente cl
join empleado em on cl.codigo_empleado_rep_ventas=em.codigo_empleado
join oficina ofi on ofi.region=cl.region;

#Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.

select em2.codigo_empleado,em2.nombre as Nombre_Empleado,
em1.codigo_empleado, em1.nombre as Nombre_Jefe from empleado em1
join empleado em2 on em1.codigo_empleado=em2.codigo_jefe;

#Devuelve un listado que muestre el nombre de cada empleados, el
#nombre de su jefe y el nombre del jefe de sus jefe.

select em3.codigo_empleado,em3.nombre as Nombre_Empleado,
em2.codigo_empleado, em2.nombre as Nombre_Jefe, 
em1.codigo_empleado, em1.nombre as Nombre_JefeDeJefe
from empleado em1
join empleado em2 on em1.codigo_empleado=em2.codigo_jefe
join empleado em3 on em2.codigo_empleado=em3.codigo_jefe;

#Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
select nombre_cliente,pe.* from cliente cl
join pedido pe on pe.codigo_cliente=cl.codigo_cliente
where pe.fecha_esperada<pe.fecha_entrega;

#Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
select distinct cl.nombre_cliente,pr.gama from producto pr
join detalle_pedido dp on dp.codigo_producto=pr.codigo_producto
join pedido pe on pe.codigo_pedido=dp.codigo_pedido
join cliente cl on cl.codigo_cliente=pe.codigo_cliente
order by cl.nombre_cliente asc;

#========================================================================================================================================================================
#Consultas multitabla (Composición externa)


#Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select cl.nombre_cliente, pg.* from cliente cl
left join pago pg on cl.codigo_cliente=pg.codigo_cliente
where pg.codigo_cliente is null;


#Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

select cl.nombre_cliente, pe.* from cliente cl
left join pedido pe on cl.codigo_cliente=pe.codigo_cliente
where pe.codigo_pedido is null;


#Devuelve un listado que muestre los clientes que no han realizado
#ningún pago y los que no han realizado ningún pedido.

select cl.nombre_cliente, pg.*,pe.* from cliente cl
left join pago pg on cl.codigo_cliente=pg.codigo_cliente
left join pedido pe on cl.codigo_cliente=pe.codigo_cliente
where pe.codigo_pedido is null and pg.codigo_cliente is null;

#Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

select nombre,ofi.* from empleado em
left join oficina ofi on em.codigo_oficina=ofi.codigo_oficina
where ofi.codigo_oficina is null;

#Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

select em.nombre,cl.* from empleado em
left join cliente cl on em.codigo_empleado=cl.codigo_empleado_rep_ventas
where cl.codigo_cliente is null;

#select em.nombre from empleado em;
#select distinct codigo_empleado_rep_ventas from cliente ; 

#Devuelve un listado que muestre solamente los empleados que no
#tienen un cliente asociado junto con los datos de la oficina donde trabajan.

select em.nombre as NombreEmpleado,ofi.* from empleado em
join oficina ofi on ofi.codigo_oficina=em.codigo_oficina
left join cliente cl on em.codigo_empleado=cl.codigo_empleado_rep_ventas
where cl.codigo_cliente is null;

#Devuelve un listado que muestre los empleados que no tienen una
#oficina asociada y los que no tienen un cliente asociado.

select em.nombre as NombreEmpleado,ofi.* from empleado em
left join oficina ofi on ofi.codigo_oficina=em.codigo_oficina
left join cliente cl on em.codigo_empleado=cl.codigo_empleado_rep_ventas
where ofi.codigo_oficina is null and cl.codigo_cliente is null;

#Devuelve un listado de los productos que nunca han aparecido en un pedido.

select pr.nombre from producto pr
right join detalle_pedido dpe on dpe.codigo_producto=pr.codigo_producto
where dpe.codigo_producto is null;


#Devuelve un listado de los productos que nunca han aparecido en un
#pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

select pr.nombre, pr.descripcion from producto pr
right join detalle_pedido dpe on dpe.codigo_producto=pr.codigo_producto
where dpe.codigo_producto is null;

#Devuelve las oficinas donde no trabajan ninguno de los empleados que
#hayan sido los representantes de ventas de algún cliente que haya
#realizado la compra de algún producto de la gama Frutales.

select distinct ofi.* from oficina ofi  
join empleado em on ofi.codigo_oficina=em.codigo_oficina
join cliente cl on cl.codigo_empleado_rep_ventas=em.codigo_empleado
join pedido pe on pe.codigo_cliente=cl.codigo_cliente
join detalle_pedido dpe on dpe.codigo_pedido=pe.codigo_pedido
join producto pr on pr.codigo_producto=dpe.codigo_producto
where pr.gama!="Frutales";


-- Paso 1: Encontrar los empleados que han sido representantes de ventas de clientes que compraron productos de la gama "Frutales"
WITH empleados_frutales AS (
    SELECT DISTINCT e.codigo_empleado
    FROM empleado e
    JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
    JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
    JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
    WHERE pr.gama = 'Frutales'
)

-- Paso 2: Encontrar las oficinas donde no trabajan estos empleados
SELECT o.codigo_oficina, o.ciudad, o.pais, o.region, o.codigo_postal, o.telefono, o.linea_direccion1, o.linea_direccion2
FROM oficina o
WHERE o.codigo_oficina NOT IN (
    SELECT DISTINCT e.codigo_oficina
    FROM empleado e
    JOIN empleados_frutales ef ON e.codigo_empleado = ef.codigo_empleado
);

#Devuelve un listado con los clientes que han realizado algún pedido
#pero no han realizado ningún pago.

select cl.nombre_cliente,pa.* from cliente cl
join pedido pe on pe.codigo_cliente=cl.codigo_cliente
left join pago pa on pa.codigo_cliente=pe.codigo_cliente
where pa.codigo_cliente is null;

SELECT  c.nombre_cliente
FROM cliente c
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE c.codigo_cliente NOT IN (
    SELECT codigo_cliente
    FROM pago
);

#Devuelve un listado con los datos de los empleados que no tienen
#clientes asociados y el nombre de su jefe asociado.

select em1.nombre as empleado,em2.nombre as jefe,cl.* from empleado em1
left join cliente cl on cl.codigo_empleado_rep_ventas=em1.codigo_empleado
join empleado em2 on em2.codigo_empleado=em1.codigo_jefe
where cl.codigo_cliente is null;

#========================================================================================================================================================================
#Consultas resumen
#¿Cuántos empleados hay en la compañía?

select count(*) as NroEmpleados from empleado;

#¿Cuántos clientes tiene cada país?

select pais,count(*) from cliente
group by pais;

#¿Cuál fue el pago medio en 2009?

select AVG(total) from pago
where YEAR(fecha_pago)=2009;

#¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma
#descendente por el número de pedidos.

select estado,count(codigo_pedido) as cant_pedidos from pedido
group by estado
order by cant_pedidos desc;

#Calcula el precio de venta del producto más caro y más barato en una misma consulta.

SELECT 
    MAX(precio_venta) AS precio_mas_caro,
    MIN(precio_venta) AS precio_mas_barato
FROM 
    producto;
    
#Calcula el número de clientes que tiene la empresa.

select count(codigo_cliente) as NumeroClientesEmpresa from cliente;

#¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

select count(codigo_cliente) from cliente
where ciudad="Madrid";

#¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?

select ciudad, count(*) as totalClientes from cliente
where ciudad like "M%"
group by ciudad;

#Devuelve el nombre de los representantes de ventas y el número de
#clientes al que atiende cada uno.

select em.nombre, count(codigo_cliente) from empleado em
join cliente cl on cl.codigo_empleado_rep_ventas=em.codigo_empleado
group by cl.codigo_empleado_rep_ventas;

#Calcula el número de clientes que no tiene asignado representante de ventas.

select count(*) from cliente 
where codigo_empleado_rep_ventas is null;

#Calcula la fecha del primer y último pago realizado por cada uno de los
#clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.

select cl.nombre_cliente, cl.apellido_contacto,  min(fecha_pago), max(fecha_pago) from pago pg
join cliente cl on cl.codigo_cliente=pg.codigo_cliente
group by cl.nombre_cliente;




















    
    













