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























    
    













