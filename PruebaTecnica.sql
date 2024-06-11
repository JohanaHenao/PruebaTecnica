--CREATE DATABASE Prueba
use Prueba

--1. Creación de modelo relacional
CREATE TABLE Paciente 
(PacienteID int identity (1,1)  primary key 
,Nombre varchar (50) not null
,Apellido varchar (50) not null
,Direccion varchar (100) not null
,Telefono varchar (15)
,Email varchar (50)
)

CREATE TABLE HistoriaClinica
(HistoriaCID int identity (1,1)  primary key 
,PacienteID int
,FechaUltimaVisita DATE
,FOREIGN KEY (PacienteID) REFERENCES Paciente(PacienteID)
)

CREATE TABLE Especialidad 
(EspecialidadID int identity (1,1)  primary key 
,Nombre Varchar(100) Not null
)

CREATE TABLE Medico
(MedicoID int identity (1,1)  primary key 
,Nombre varchar (50) not null
,Apellido varchar (50) not null
,Email varchar (50) 
,EspecialidadID int not null
,FOREIGN KEY (EspecialidadID) REFERENCES Especialidad(EspecialidadID)
)

CREATE TABLE Diagnostico
(DiagnosticoID int identity (1,1)  primary key 
,Diagnostico varchar(max)
)


CREATE TABLE Visita
(VisitaID int identity (1,1)  primary key 
 ,PacienteID int not null
 ,MedicoID int not null
 ,FechaVisita date not null
 ,DiagnosticoID int not null
 ,Tratamiento varchar(max)
 ,FOREIGN KEY (PacienteID) REFERENCES Paciente(PacienteID)
 ,FOREIGN KEY (MedicoID) REFERENCES Medico(MedicoID)
 ,FOREIGN KEY (DiagnosticoID) REFERENCES Diagnostico(DiagnosticoID)
)

INSERT INTO Diagnostico (Diagnostico) VALUES (Fiebre)
INSERT INTO Diagnostico (Diagnostico) VALUES (Hipertension)
INSERT INTO Diagnostico (Diagnostico) VALUES (Diabetes)


INSERT INTO Especialidad(Nombre) VALUES (Cardiología)
INSERT INTO Especialidad(Nombre) VALUES (Geriatria)
INSERT INTO Especialidad(Nombre) VALUES (Pediatría)
INSERT INTO Especialidad(Nombre) VALUES (Psiquiatría)
INSERT INTO Especialidad(Nombre) VALUES (Neurología)

INSERT INTO Medico (Nombre, Apellido, Email, EspecialidadID) VALUES('Fernando', 'Castro',	'fernandocastro@gmail.com',	1)
INSERT INTO Medico (Nombre, Apellido, Email, EspecialidadID) VALUES('Aldemar',	'Guzmán',	'aldemarguzman@gmai.com',	3)
INSERT INTO Medico (Nombre, Apellido, Email, EspecialidadID) VALUES('Catalina',	'Carmona',	'catalinacarmona@gmail.com',	4)
INSERT INTO Medico (Nombre, Apellido, Email, EspecialidadID) VALUES('Alexandra',	'Aguirre',	'alexandraaguirre@gmail.com',	3)


INSERT INTO Paciente (PacienteID, Nombre, Apellido, Direccion, Telefono, Email) VALUES ('Sandra',	'Restrepo',	'Calle 25 F No. 43-18',	'5542684',	'sandrarestrepo@gmail.com')
INSERT INTO Paciente (PacienteID, Nombre, Apellido, Direccion, Telefono, Email) VALUES ('Javier',	'Vanegas',	'Carrera 48 No 26-17',	'8453216',	'javiervanegas@gmail.com')
INSERT INTO Paciente (PacienteID, Nombre, Apellido, Direccion, Telefono, Email) VALUES ('Dary',	'Salinas',	'Avenida 32 No 57-19',	'6321476',	'darysalinas@gmail.com')

--2. Store Procedure
alter PROCEDURE RegistroVisita 
@PacienteID int
 ,@MedicoID int
 ,@FechaVisita date
 ,@DiagnosticoId int 
 ,@Tratamiento varchar(max)
 as
 BEGIN 

	 INSERT INTO Visita(PacienteId, MedicoId, FechaVisita,DiagnosticoID,Tratamiento)
	 values (@PacienteId, @MedicoId, @FechaVisita,@DiagnosticoID,@Tratamiento)

	 IF NOT EXISTS(SELECT 1 FROM HistoriaClinica WHERE PacienteId = @PacienteID)
	 BEGIN
		 INSERT INTO HistoriaClinica(PacienteId,FechaUltimaVisita)
		 VALUES (@PacienteID, @FechaVisita)
	 END
 end



--3. Trigger
ALTER TRIGGER ActualizaFechaUltimaVisita
 ON Visita AFTER INSERT
 AS
BEGIN

	DECLARE @UltimoID int;

	SELECT @UltimoID = MAX(VisitaID) FROM VISITA

	
	UPDATE HC 
	SET HC.FechaUltimaVisita = V.UltimaVisita
	FROM HistoriaClinica HC
	INNER JOIN (SELECT PACIENTEID, MAX(FECHAVISITA) UltimaVisita FROM VISITA GROUP BY PacienteID
			   ) as V
			   on hc.PACIENTEID = v.PACIENTEID
	where hc.PACIENTEID = v.PACIENTEID

END



--4. Escriba una consulta SQL que liste todos los pacientes y su última fecha de visita, ordenados por la fecha de la última visita en orden descendente.

SELECT P.*, max(V.FechaVisita) FechaUltimaVisita
FROM PACIENTE P
INNER JOIN VISITA V
		ON P.PacienteId = V.PacienteID
group by P.PacienteID, P.Nombre, P.Apellido, P.Direccion, P.Telefono, P.Email
order by max(V.FechaVisita) desc



--5. Estrategias para asegurar la integridad y el rendimiento de la base de datos
/*
1. Creación de índices y restricciones de integridad para garantizar que los datos cuumplan con ciertas reglas o condiciones que permitar tener datos válidos y consistentes 
2. Realizar un monitoreo periodico a la base de datos, incluyendo auditorias que permitan la trazabilidad de los movimientos realizados por los usuarios 
*/