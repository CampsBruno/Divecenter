
-- -----------------------------------Vistas Relacionadas a CURSOS


--  Cursos hechos por cada alumno, junto a sus dias de cursada y el estado actual del curso
 select * from Vista_InformacionAlumnos; 
 
 -- Instructores, su estado actual y que cursos dictan
  select * from Estado_Instructores order by Fecha_Inicio desc; -- Mejora sustancial en la distribucion de instructores a los cursos por realizarse
  
  -- equipo asignado a los alumnos en cursos 
  SELECT * FROM VW_Equipos_Usados_en_Curso; -- Permite  organizar de forma más fácil y detallada que equipos fueron usados por cada alumno
  
  SELECT * FROM VW_Equipos_Usados_en_Curso where Equipo= 'Chaleco BCD';   -- Nos permite hacer campañas de marketing focalizadas a buzos que no dispongan de un equipo en particular
-- ---------


--  Permite saber cuantos alumnos en una epoca del año toman un determinado curso
SELECT Nomnbre_Curso, Fecha_Inicio, ID_Curso, 
       row_number() OVER (PARTITION BY YEAR(Fecha_Inicio) ORDER BY Fecha_Inicio ASC) AS "Numero de Alumnos que Cursaron"
FROM Vista_InformacionAlumnos
WHERE MONTH(Fecha_Inicio) = 7;                -- Numero de alumnos que tomaron un determinado curso en Julio, separado por año



-- ----------------------- Vistas Relacionadas a  Viajes

-- alumnos asisten a cada viaje, que curso realizan y cual es el instructor asignado al viaje
 select * from Informacion_Viajes;  
 
 -- Estado de los pagos realizados por los alumnos para cada viaje
 select * from Estado_Pagos; 
 
 -- Instructores asignados a los viajes
 select * from Vista_Viajes_Instructores; 
 
 -- Informacion decada alumno que va a los viajes, que isntructor asiste y que equipo utilizo en el curso para poder asignarle el mismo o similar
Select * from VW_Equipos_Escuela_Viajes;   -- facilita enormemente la distribucion de los equipos de buceo y permite saber si nos faltan talles adecuados para los viajes


 --  --------------------------------------Vistas relacionadas a ventas y Equipo Disponible
 -- Equipos del Divecenter
SELECT * FROM VW_Vista_Equipo_Escuela; -- Permite  organizar de forma más fácil y detallada que equipos se pueden usar y cuales están en reparación. 

 -- Equipo destinada para ventas
  select * from VW_Equipo_Disponible_Ventas;  -- permite controlar facilmente el stock
  
  -- Equipo vendido y a que alumno se vendio
 SELECT * FROM VW_eQUIPO_vENDIDO;   
 
 
 

 
 --  ------------------------------------------------- PROCEDIMIENTOS
 
 -- Permite saber cuantos buzos de un determinado rango asisten o asistieron a los viajes de buceo, tambien, brinda informacion  sobre el viaje y el estado de los pagos
 CALL Busca_enViajes_Alumnos_Curso('Open Water Diver'); -- Facilita mucho, para saber de una forma rapida, cuantos buzos iniciales, intermedios o avanzados asisten a cada viaje de buceo
 -- ejemplos de otros rangos 'Advanced Open Water Diver' 
 

--  Permite ver todo el historial de cursada de un alumno solamente poniendo el apellido
 CALL Busca_Historial_Alumno("sosa");
 
 
 -- ------------------------------------------------------------  FUNCIONES
 
 
 -- Sumo el total de la recaudacion para un viaje de buceo en particular
SELECT RecaudacionTotal(1) AS TotalRecaudado;  -- como input ID_Viaje 
-- select * from viajes_escuela;  -- id de cada viaje

-- Agregamos el codigo del curso y nos dice cuantos cursos se estan dictando actualmente de ese nivel
SELECT CantidadCursosDisponibles(1) as "Cantidad de Cursos dictados Actualmente";
-- select * from cursos_disponibles;  --  Aca estan los codigos

 
 
 
 
 
 
 -- --- ----------------------------------------------     DATO DE PRUEBA   para TRIGGERS   ------------------------------------------------------
 
 --   2 Triggers, de Reistro de datos en la tabla alumnos_cursando y de delecion de datos, ambos los copia en la tabla Copia_Cursando
 
 -- ---------------    1) TESTEO DEL FUNCIONAMIENTO  
 -- INSERT INTO Alumnos_Cursando (ID_Alumno, ID_Curso) VALUES  (3, 3);    --  Agrego Alumnos a Cursada
-- select * from Copia_Cursando order by fecha desc;   --   Corroboro los datos
-- ---------------   2) TESTEO DEL FUNCIONAMIENTO  
 -- select * from Copia_Cursando;                 --     En esta tabla se agregan los alumnos

--  SELECT* FROM alumnos_cursando;

 -- DELETE  FROM alumnos_cursando WHERE ID_Alumno=5;       -- Elimino alumno   (si el id 5 no esta poner otro valor)

-- select * from Copia_Cursando order by fecha desc;   --   Corroboro los datos

--   --------------------fin del testeo de funcionamiento




-- --- ----------------------------------------------     DATO DE PRUEBA   ------------------------------------------------------
-- - -------------------      Registra la delecion de  registros en Venta_Equipo

--  select * from Registro_Ventas;

--   DELETE FROM Venta_Equipo WHERE Venta_N=1;

--   select * from Registro_Ventas;

                            




-- --- ----------------------------------------------     DATO DE PRUEBA   ------------------------------------------------------
--   descuenta la cantidad adquirida y calcula el importe a agregar en la tabla de venta_equipo

--  select * from equipo_para_ventas;
--  select * from venta_equipo;
--  INSERT INTO venta_equipo(Id_Equipo_Vendido,ID_Alumno,Cantidad) values (1,1,1);
--  select * from equipo_para_ventas;
 -- select * from venta_equipo;