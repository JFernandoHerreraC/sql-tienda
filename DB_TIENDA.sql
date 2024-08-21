CREATE DATABASE TIENDA
GO

USE TIENDA


CREATE TABLE AREAS_TRABAJO(
	id_atr NUMERIC(2,0) PRIMARY KEY IDENTITY(1,1),
	nombre_atr VARCHAR(40) NOT NULL,
	descripcion_atr VARCHAR(70) NOT NULL
)

CREATE TABLE TRABAJADOR(
	id_tr NUMERIC(3,0) PRIMARY KEY IDENTITY(1,1),
	nombre_tr VARCHAR(45) NOT NULL,
	apaterno_tr VARCHAR(45) NOT NULL,
	amaterno_tr VARCHAR(45) NULL,
	sexo_tr CHAR(2) NOT NULL,
	fecha_nac_tr DATE NOT NULL,
	domicilio_tr VARCHAR(75) NOT NULL,
	telefono_movil_tr VARCHAR(12) NOT NULL,
	telefono_fijo_tr VARCHAR(12) NULL,
	correo_electronico_tr VARCHAR(45) NOT NULL,
	id_area_trabajo_tr NUMERIC(2,0),
	CONSTRAINT CK_SEXOTRABAJADOR CHECK(sexo_tr = 'M' OR sexo_tr = 'F'),
	CONSTRAINT FK_AREATRABAJO FOREIGN KEY(id_area_trabajo_tr) REFERENCES AREAS_TRABAJO(id_atr)
)


CREATE TABLE CATEGORIA(
	id_ctg NUMERIC(3,0) PRIMARY KEY IDENTITY(1,1),
	nombre_ctg VARCHAR(35) NOT NULL,
	descripcion_ctg VARCHAR(75) NULL
)

CREATE TABLE PROVEEDOR(
	id_prov NUMERIC(3,0) PRIMARY KEY IDENTITY(1,1),
	nombre_prov VARCHAR(75) NOT NULL,
	telefono_prov VARCHAR(12) NOT NULL,
	direccion_prov VARCHAR(75) NOT NULL,
	rfc_prov VARCHAR(13) NOT NULL,
	tipo_persona_prov VARCHAR(2),
	CONSTRAINT CK_TIPODEPERSONA CHECK(tipo_persona_prov = 'M' OR tipo_persona_prov = 'F'),
)



CREATE TABLE PRODUCTO (
	id_prod NUMERIC(8,0) PRIMARY KEY IDENTITY(1,1),
	nombre_prod VARCHAR(40) NOT NULL,
	descripcion_prod VARCHAR(75) NOT NULL,
	precio_prod DECIMAL(4,0) NOT NULL,
	stock_prod DECIMAL(4,0) NOT NULL,
	existencia_prod NUMERIC(4,0) NOT NULL,
	id_ctg NUMERIC(3,0),
	id_proveedor_prod NUMERIC(3,0)
	CONSTRAINT FK_IDCTGX FOREIGN KEY (id_ctg) REFERENCES CATEGORIA(id_ctg),
	CONSTRAINT FK_idcategoria FOREIGN KEY (id_proveedor_prod) REFERENCES PROVEEDOR(id_prov)
)


CREATE TABLE CARRITO(
	id_crr NUMERIC(10,0) PRIMARY KEY IDENTITY(1,1),
	id_trabajador_crr NUMERIC(3,0),
	fecha_crr DATE NOT NULL,
	hora_crr TIME NOT NULL,
	impuesto_crr DECIMAL NOT NULL,
	descuentos_crr DECIMAL NOT NULL,
	total_crr DECIMAL NOT NULL,
	CONSTRAINT FK_EMPLEADOS FOREIGN KEY (id_trabajador_crr) REFERENCES TRABAJADOR(id_tr)
)


CREATE TABLE AUX_CARRITO(
	id_axcrr NUMERIC(4,0),
	id_carrito_axcrr NUMERIC(10,0),
	id_producto_axcrr NUMERIC(8,0),
	cantidad_axcrr Numeric(3,0) NOT NULL,
	importe_axcrr DECIMAL NOT NULL,
	total_axcrr DECIMAL NOT NULL,
	CONSTRAINT PK_PRIMARIACOMPUESTA PRIMARY KEY(id_axcrr, id_carrito_axcrr, id_producto_axcrr),
	CONSTRAINT FK_CARRITOAUX FOREIGN KEY (id_carrito_axcrr) REFERENCES CARRITO(id_crr),
	CONSTRAINT FK_PRODUCTO FOREIGN KEY (id_producto_axcrr) REFERENCES PRODUCTO(id_prod)
)

GO


INSERT INTO AREAS_TRABAJO(nombre_atr, descripcion_atr) VALUES('ALMACEN','ENCARGADO DE RECIBIR LOS PRODUCTOS Y ALMACENARLO');
INSERT INTO TRABAJADOR(nombre_tr, 
						apaterno_tr, 
						amaterno_tr, 
						sexo_tr, 
						fecha_nac_tr, 
						domicilio_tr, 
						telefono_movil_tr, 
						telefono_fijo_tr, 
						correo_electronico_tr, 
						id_area_trabajo_tr) 
						VALUES('JOSE', 'HERNANDES', 'GOMEZ', 'M', '03/25/1975', 'LIBERTAD #16, COLONIA VERACRUZ CENTRO 94000', '229', '229', 'JOSE@EXAMPLE.COM', 1);

/* SELECCION DE EMPLEADOS*/
SELECT TR.nombre_tr + ' ' + TR.apaterno_tr + ' ' + TR.amaterno_tr AS 'NOMBRE COMPLETO', 
		CASE TR.sexo_tr WHEN 'F' THEN 'FEMENINO' WHEN 'M' THEN 'MASCULINO' END AS SEXO, TR.fecha_nac_tr, DATEDIFF(YEAR, TR.fecha_nac_tr, GETDATE()) AS EDAD,
		TR.domicilio_tr, TR.telefono_movil_tr, TR.telefono_fijo_tr, 
		TR.correo_electronico_tr, ATR.nombre_atr AS 'AREA DE TRABAJO', ATR.descripcion_atr AS 'DESCRIPCIÓN DE ACT.'
FROM TRABAJADOR AS TR
LEFT JOIN AREAS_TRABAJO AS ATR
ON TR.id_area_trabajo_tr = ATR.id_atr

/*CREACIÓN  DE VISTA*/
CREATE OR ALTER VIEW  VISTAEMPLEADOS AS
	SELECT TR.id_tr AS 'ID', TR.nombre_tr + ' ' + TR.apaterno_tr + ' ' + TR.amaterno_tr AS 'NOMBRE COMPLETO', 
		CASE TR.sexo_tr WHEN 'F' THEN 'FEMENINO' WHEN 'M' THEN 'MASCULINO' END AS SEXO, TR.fecha_nac_tr, DATEDIFF(YEAR, TR.fecha_nac_tr, GETDATE()) AS EDAD,
		TR.domicilio_tr, TR.telefono_movil_tr, TR.telefono_fijo_tr, 
		TR.correo_electronico_tr, ATR.nombre_atr AS 'AREA DE TRABAJO', ATR.descripcion_atr AS 'DESCRIPCIÓN DE ACT.'
	FROM TRABAJADOR AS TR
	LEFT JOIN AREAS_TRABAJO AS ATR
	ON TR.id_area_trabajo_tr = ATR.id_atr;
GO
SELECT * FROM VISTAEMPLEADOS;

