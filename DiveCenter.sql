create database if not exists DiveCenter;

use Divecenter;



-- ---------------------------------------------------     TABLAS   -----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS cursos_Disponibles(
	Codigo_Curso int NOT NULL auto_increment,
    Nomnbre_Curso varchar(80) NOT NULL,
    Estado_Curso BOOLEAN NOT NULL,
    PRIMARY KEY (Codigo_Curso)
);



CREATE TABLE IF NOT EXISTS Cursos_dictados(
    Id_Curso int NOT NULL auto_increment,
    Codigo_Curso int NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Dias_Cursada VARCHAR(10) NOT NULL,
    Estado BOOL NOT NULL,
    PRIMARY KEY(Id_Curso),
    FOREIGN KEY (Codigo_Curso) REFERENCES Cursos_Disponibles(Codigo_Curso)
);


CREATE TABLE IF NOT EXISTS Instructores(
	Id_Instructor int NOT NULL auto_increment,
    Nombre VARCHAR(20) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    Fecha_Nac DATE NOT NULL,
    Registro_Buzo int NOT NULL,
    Rango VARCHAR(30) NOT NULL, 
    Estado BOOLEAN NOT NULL,
    PRIMARY KEY(Id_Instructor)

);

CREATE TABLE IF NOT EXISTS Talles(
ID_Talle int not null auto_increment,
Talle varchar(80) not null,
PRIMARY kEY (ID_Talle));

CREATE TABLE IF NOT EXISTS Cursos_Asignados(
	ID_Asignacion int NOT NULL auto_increment,
    ID_Instructor int NOT NULL,
    ID_Curso int NOT NULL,
    PRIMARY KEY(Id_Asignacion),
    FOREIGN KEY (ID_Curso) REFERENCES Cursos_Dictados(ID_Curso),
	FOREIGN KEY (ID_Instructor) REFERENCES Instructores(ID_Instructor)

);


CREATE TABLE IF NOT EXISTS Alumnos(
	Id_Alumno int NOT NULL auto_increment,
    Nombre VARCHAR(30)  NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    Fecha_Nac DATE,
    PRIMARY KEY (Id_Alumno)

);

CREATE TABLE IF NOT EXISTS Alumnos_Cursando(
	ID int NOT NULL auto_increment,
    ID_Alumno int NOT NULL,
    ID_Curso  int NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(Id_Alumno),
    FOREIGN KEY (ID_Curso) REFERENCES Cursos_Dictados(ID_Curso)
);

CREATE TABLE IF NOT EXISTS Viajes_Escuela(
	ID_Viaje int NOT NULL auto_increment,
    Destino VARCHAR(80) NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE NOT NULL,
    PRIMARY KEY(ID_Viaje)
);

CREATE TABLE IF NOT EXISTS Alumnos_Asignados( 
	ID INT NOT NULL auto_increment,
    ID_Viaje INT NOT NULL,
    ID_Alumno INT NOT NULL,
    Estado_Pago REAL NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_Viaje) REFERENCES Viajes_Escuela(ID_Viaje),
    FOREIGN KEY(ID_Alumno) REFERENCES Alumnos(ID_Alumno)
);

CREATE TABLE IF NOT EXISTS Viajes_Instructor(
	ID  INT NOT NULL auto_increment,
    ID_Instructor INT NOT NULL,
    ID_Viaje INT NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY (ID_Instructor)REFERENCES Instructores(Id_Instructor),
    FOREIGN KEY(ID_Viaje) REFERENCES Viajes_Escuela(ID_Viaje) 
);

CREATE TABLE IF NOT EXISTS Equipo_Disponible(
	Codigo_Equipo INT NOT NULL Auto_increment,
    Nombre_Equipo VARCHAR(200) NOT NULL,
	PRIMARY KEY(Codigo_Equipo)
);

CREATE TABLE IF NOT EXISTS  Equipo_Para_Ventas(
	 Id_Equipo_Venta INT NOT NULL AUTO_INCREMENT,
     Tipo_Equipo  INT  NOT NULL,
     Talle int not null,
     Marca VARCHAR(50) NOT NULL,
     Cantidad INT NOT NULL DEFAULT 0,
     Precio REAL,
     PRIMARY KEY (Id_Equipo_Venta),
     FOREIGN KEY (Tipo_Equipo) REFERENCES Equipo_Disponible(Codigo_Equipo),
     FOREIGN KEY (Talle) REFERENCES Talles (ID_Talle)
);

CREATE TABLE IF NOT EXISTS Venta_Equipo(
	Venta_N INT NOT NULL auto_increment,
    Id_Equipo_Vendido INT NOT NULL,
    ID_Alumno INT DEFAULT NULL,
    Importe REAL default NULL,
    Fecha DATE ,
    Cantidad int not null,
    PRIMARY KEY (Venta_N),
    FOREIGN KEY (Id_Equipo_Vendido) REFERENCES Equipo_Para_Ventas(Id_Equipo_Venta),
     FOREIGN KEY (ID_Alumno) REFERENCES AlumnoS(ID_Alumno)
);





CREATE TABLE IF NOT EXISTS Equipo(
	Id_Equipo INT NOT NULL auto_increment,
    Tipo_Equipo INT NOT NULL,
    Talle int not null ,
    Marca VARCHAR(50) ,
    Estado BOOL DEFAULT 1,
    ULTIMO_MANTENIMIENTO DATE DEFAULT NULL,
    Fecha_Compra DATE,
    Ultima_Inspeccion DATE,
    Dueño VARCHAR(80),
    Observacion VARCHAR(200),
    PRIMARY KEY(Id_Equipo),
    FOREIGN KEY(Tipo_Equipo) REFERENCES Equipo_Disponible(Codigo_Equipo),
     FOREIGN KEY (Talle) REFERENCES Talles (ID_Talle)
);


CREATE TABLE IF NOT EXISTS Equipo_Asignado_Curso(
Id_Asignado INT NOT NULL AUTO_INCREMENT,
Id_Equipo INT NOT NULL,
Id_Alumno_Cursando INT NOT NULL,
Fecha DATE,
PRIMARY KEY(Id_Asignado),
FOREIGN KEY(Id_Equipo) REFERENCES Equipo(Id_Equipo),
foreign key(Id_Alumno_Cursando) REFERENCES alumnos_cursando(ID)
);



CREATE TABLE IF NOT EXISTS Copia_Cursando (
ID int not null,
ID_Alumno INT not null,
id_Curso int not null,
Usuario varchar (100),
Accion varchar(50),
fecha DATETIME 

);


CREATE TABLE IF NOT EXISTS Registro_Ventas(
Id_Equipo_Vendido int not null,
id_Alumno int,
importe FLOAT not null,
Usuario varchar(100),
Accion varchar(50),
fecha DATETIME 
);




--  ----------------------------------------------------   STORE PROCEDURES    -------------------------------------------------------------


-- Poniendo un apellido, trae todos los datos del alumno, los cursos ya realizados y los cursos que se estan dictando
 DELIMITER $$
 CREATE PROCEDURE Busca_Historial_Alumno(in Apellido_Usuario varchar(250))
 BEGIN
	Select 	alumno.Id_Alumno,alumno.Nombre,alumno.Apellido, alumno.Fecha_Nac, 
			curso.Nomnbre_Curso,curso.dias_cursada,curso.fecha_inicio,curso.estado  
	from 
			(select a.*, l.id_curso  from alumnos a
			JOIN alumnos_cursando l on l.ID_Alumno = a.Id_Alumno
			where apellido= Apellido_Usuario) as alumno
	JOIN
			(SELECT c.Nomnbre_Curso, c.Estado_curso, cd.fecha_inicio, cd.dias_Cursada, cd.Estado, cd.id_curso
			FROM cursos_dictados cd
			JOIN cursos_disponibles c on cd.ID_Curso= c.Codigo_curso) curso
            
	ON alumno.id_curso= curso.ID_Curso
    
	ORDER BY alumno.id_alumno and curso.estado desc;

END $$
DELIMITER ;

-- CALL Busca_Historial_Alumno("sosa");


-- Seleccion un curso y me dice cuanta gente de ese curso va a ir o fue  a los viajes de buceo
DELIMITER $$
CREATE PROCEDURE Busca_enViajes_Alumnos_Curso(IN Nombre_Curso VARCHAR(80))
BEGIN
    SELECT 
        ve.id_viaje,
        ve.destino,
        a.Nombre,
        a.Apellido,
        a.Fecha_Nac,
        cd.Nomnbre_Curso,
        aa.Estado_Pago,
        ve.fecha_inicio,
        ve.fecha_fin
    FROM 
        Alumnos_Asignados aa
    JOIN 
        Alumnos a ON aa.ID_Alumno = a.ID_Alumno
    JOIN 
        Viajes_Escuela ve ON aa.ID_Viaje = ve.ID_Viaje
    JOIN
		alumnos_cursando al ON al.ID=aa.ID_Alumno
    JOIN
     cursos_dictados ccd ON ccd.Id_Curso=al.Id_Curso
    JOIN 
        Cursos_Disponibles cd ON ccd.Codigo_Curso = cd.Codigo_Curso
    WHERE 
        cd.Nomnbre_Curso = Nombre_Curso;
END $$
DELIMITER ;


-- CALL Busca_enViajes_Alumnos_Curso('Open Water Diver');



--   --------------------------------------------------------    TRIGGERS     -----------------------------------------------------------------


-- LUEGO DE ADJUNTAR VALORES A ALUMNOS CURSANDO, EL TRIGGER ALMACENA ESOS VALORES EN UNA NUEVA TABLA Y ADJUNTA QUIEN REALIZO LAS MODIFICACIONES 
DELIMITER $$
CREATE TRIGGER  Registro_Alumno
AFTER INSERT ON alumnos_cursando
FOR EACH ROW
BEGIN
INSERT INTO Copia_Cursando VALUES(NEW.ID, NEW.ID_ALUMNO,NEW.ID_Curso, USER(),"Insert Data", current_timestamp());
END $$
DELIMITER ;



-- trigger que almacena los datos antes de ser borrados de la alumnos_cursando
DELIMITER $$
CREATE TRIGGER Registro_Cursos_Antes_Delete
BEFORE DELETE ON alumnos_cursando
FOR EACH ROW
BEGIN
    INSERT INTO Copia_Cursando VALUES (OLD.ID, OLD.ID_ALUMNO, OLD.ID_Curso, USER(), "Delete Data",current_timestamp());
END $$
DELIMITER ;




DELIMITER $$  --     Registra la insercion de datos de Venta_Equipo
CREATE TRIGGER Registro_Insertar_Venta_Equipo
AFTER INSERT ON Venta_Equipo
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Ventas
    VALUES (NEW.Id_Equipo_Vendido, NEW.ID_Alumno, NEW.Importe, USER(), "Insert Data", current_timestamp());
END $$
DELIMITER ;

DELIMITER $$





CREATE TRIGGER Tr_Borrar_Venta_Equipo  --  Registra Eliminacion de datos en Venta Equipo
AFTER DELETE ON Venta_Equipo
FOR EACH ROW
BEGIN
    INSERT INTO Registro_Ventas (Id_Equipo_Vendido, id_Alumno, importe, Usuario, Accion, fecha)
    VALUES (OLD.Id_Equipo_Vendido, OLD.ID_Alumno, OLD.Importe, USER(), "Delete Data", current_timestamp());
END $$
DELIMITER ;




-- Corrobora si hay Stock en equipo_para_ventas, si lo hay, descuenta el equipo vendido y agrega el importe correspondiente a venta_equipo
DELIMITER $$
CREATE TRIGGER TG_Importes_Ventas
BEFORE INSERT ON  Venta_equipo
FOR EACH ROW
BEGIN
	DECLARE stock_disponible INT;
    DECLARE Precio_Unitario REAL;
    SELECT cantidad,precio INTO stock_disponible,Precio_Unitario FROM Equipo_Para_ventas WHERE Id_Equipo_Venta = new.Id_Equipo_Vendido;
    sET NEW.FECHA = current_date();
    
	IF stock_disponible >= new.cantidad  THEN
		SET new.importe =  Precio_Unitario * new.cantidad;
        UPDATE Equipo_Para_ventas SET Cantidad =  stock_disponible-new.cantidad WHERE Id_Equipo_Venta= new.Id_Equipo_Vendido;
    ELSE
      SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No hay suficiente stock disponible';
            
	END IF;
END $$
DELIMITER ;



-- ------------------------------------  CREACION DE LAS VISTAS  -----------------------------------------------------------------------

-- Vista con info de los viajes
CREATE VIEW Informacion_Viajes AS
SELECT
    ve.ID_Viaje,
    ve.Destino,
    a.Nombre AS Nombre_Alumno,
    a.Apellido AS Apellido_Alumno,
    cd.Nomnbre_Curso,
    i.Nombre AS Nombre_Instructor,
    ve.Fecha_Inicio,
    ve.Fecha_Fin
FROM
    Viajes_Escuela ve
    JOIN Alumnos_Asignados aa ON ve.ID_Viaje = aa.ID_Viaje
    JOIN Alumnos a ON aa.ID_Alumno = a.ID_Alumno
    JOIN Cursos_Disponibles cd ON ve.ID_Viaje = cd.Codigo_Curso
    JOIN Cursos_Asignados ca ON cd.Codigo_Curso = ca.ID_Curso
    JOIN Instructores i ON ca.ID_Instructor = i.ID_Instructor;



 


-- Vista Alumnos Cursando
CREATE VIEW Vista_InformacionAlumnos AS
SELECT
    a.ID_Alumno,
    
    a.Nombre,
    a.Apellido,
    cc.Nomnbre_Curso,
    cd.Dias_Cursada,
    cd.Estado,
    cd.Fecha_Inicio,
    cd.ID_Curso
FROM
    Alumnos_Cursando ac
    JOIN Alumnos a ON ac.ID_Alumno = a.ID_Alumno
    JOIN Cursos_Dictados cd ON ac.ID_Curso = cd.Id_Curso
    JOIN Cursos_Disponibles cc ON cc.Codigo_Curso= cd.Codigo_Curso;




-- Vista Alumnos que Pagaron
CREATE VIEW Estado_Pagos AS
SELECT
    ve.ID_Viaje,
    ve.Fecha_Inicio AS Fecha,
    ve.Destino,
    a.Nombre AS Nombre_Alumno,
    a.Apellido AS Apellido_Alumno,
    aa.Estado_Pago
FROM
    Viajes_Escuela ve
    JOIN Alumnos_Asignados aa ON ve.ID_Viaje = aa.ID_Viaje
    JOIN Alumnos a ON aa.ID_Alumno = a.ID_Alumno;




-- Instructores y cursos 
CREATE VIEW Estado_Instructores AS
SELECT
    i.Nombre AS Nombre_Instructor,
    i.Apellido,
    cc.Nomnbre_Curso,
    cd.Dias_Cursada,
    cd.Estado,
    cd.Fecha_Inicio
FROM
    Cursos_Asignados ca
    JOIN Instructores i ON ca.ID_Instructor = i.ID_Instructor
    JOIN Cursos_Dictados cd ON ca.ID_Curso = cd.ID_Curso
    JOIN Cursos_Disponibles cc ON cc.Codigo_Curso= cd.Codigo_Curso;




-- Viajes Instructores
CREATE VIEW Vista_Viajes_Instructores AS
SELECT
    ve.ID_Viaje,
    ve.Destino,
    i.Nombre AS Nombre_Instructor,
    i.Apellido AS Apellido_Instructor,
    ve.Fecha_Inicio,
    ve.Fecha_Fin
FROM
    Viajes_Instructor vi
    JOIN Instructores i ON vi.ID_Instructor = i.ID_Instructor
    JOIN Viajes_Escuela ve ON vi.ID_Viaje = ve.ID_Viaje;





CREATE VIEW VW_Equipo_Disponible_Ventas AS
SELECT
    e.Nombre_Equipo,
    tal.talle,
    pv.marca,
    pv.cantidad,
    pv.precio
    FROM equipo_para_ventas pv
    JOIN equipo_disponible e 
    ON pv.Tipo_Equipo=e.Codigo_Equipo 
    JOIN talles tal ON  tal.ID_Talle=  pv.talle;
    
   


-- Vistas de equipo vendido
CREATE VIEW VW_eQUIPO_vENDIDO AS
SELECT
    VE.Venta_N as "Venta N°",
    E.Nombre_Equipo AS "Equipo Vendido",
    TA.Talle as "Talle",
    EV.MARCA as "Marca",
    AL.NOMBRE,
    AL.APELLIDO,
    VE.cantidad,
    VE.importe,
    VE.Fecha,
    AL.Id_Alumno as "Codigo Alumno"
FROM equipo_para_ventas EV
JOIN equipo_disponible E ON  E.Codigo_Equipo= EV.Tipo_Equipo
JOIN venta_equipo VE ON    EV.Id_Equipo_Venta =VE.Id_Equipo_Vendido
JOIN ALUMNOS AL ON AL.ID_Alumno=VE.ID_Alumno
JOIN talles TA ON TA.ID_Talle = EV.TALLE;
    

 


-- View que Muestra el EQUIPO ASIGNADO A UN ALUMNO EN UN CURSO
CREATE VIEW VW_Equipos_Usados_en_Curso as
SELECT 
   EQA.Id_Asignado,
   EQA.Id_Alumno_cursando,
   al.Nombre,
   al.Apellido,
   ed.Nombre_Equipo as "Equipo",
   ta.Talle,
   eq.Marca,
   eq.Estado,
   eqa.fecha as 'Fecha Que se Uso',
   EQ.Dueño,
   eq.Observacion,
   EQ.Estado as "Estado Actual"
FROM
  equipo_asignado_curso EQA 
  JOIN alumnos_cursando EE ON EE.ID= EQA.Id_Alumno_Cursando
  JOIN equipo EQ ON EQ.ID_EQUIPO = EQA.Id_Equipo
  JOIN equipo_disponible ED ON ED.Codigo_Equipo = EQ.Tipo_Equipo
  JOIN alumnos AL ON AL.Id_Alumno=EE.ID_Alumno
  JOIN talles ta ON ta.id_talle = EQ.talle;



 
 -- Equipo y talle
 CREATE VIEW VW_Vista_Equipo_Escuela as   -- vista detallada de los equipos disponibles del Divecenter
 SELECT 
	EQ.id_equipo,
	ED.Nombre_equipo as "Equipo",
	T.Talle,
    EQ.Marca,
    EQ.Estado,
    EQ.Ultimo_Mantenimiento,
    EQ.Fecha_Compra,
    EQ.Ultima_inspeccion,
    EQ.Dueño,
    EQ.Observacion
FROM 	
	Equipo EQ
	JOIN Equipo_Disponible  ED ON ED.Codigo_Equipo = EQ.Tipo_Equipo
    JOIN Talles T ON T.id_Talle = EQ.Talle;
 
 
 --  Vista Equipos a llevar viajes
 CREATE VIEW VW_Equipos_Escuela_Viajes as  -- nos da los equipos asignados a cada alumno durantre los cursos y cual le tendriamos qeu llevar al viaje de buceo 
 SELECT 
    iv.ID_Viaje,
    euq.id_alumno_Cursando AS "ID Alumno",
    iv.Destino,
    iv.Nombre_alumno AS "Nombre Alumno",
    iv.apellido_alumno AS "Apellido Alumno",
    iv.Nomnbre_Curso AS "Nivel de Buzo",
    iv.Nombre_Instructor,
    iv.fecha_inicio AS "Inicio Viaje",
    iv.fecha_fin AS "Fin Viaje",
    euq.Equipo AS "Equipo Usado",
    euq.Talle,
    euq.Marca,
    euq.dueño,
    euq.Observacion,
    euq.Estado Actual
    
FROM
    Informacion_Viajes iv
        JOIN
    VW_Equipos_Usados_en_Curso euq
WHERE
    iv.Nombre_Alumno = euq.Nombre;
    


