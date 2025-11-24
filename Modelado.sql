-- =====================================================
-- PROYECTO: Sistema Electoral Registraduría Nacional
-- BASE DE DATOS: SQLite
-- AUTOR: Jesús David Rangel
-- =====================================================

-- ===========================
-- 1. CREACIÓN DE TABLAS
-- ===========================

CREATE TABLE departamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE
);

CREATE TABLE municipio (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    departamento_id INTEGER NOT NULL REFERENCES departamento(id)
);

CREATE TABLE puesto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    direccion TEXT,
    municipio_id INTEGER NOT NULL REFERENCES municipio(id)
);

CREATE TABLE mesa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero INTEGER NOT NULL,
    puesto_id INTEGER NOT NULL REFERENCES puesto(id)
);

CREATE TABLE partido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    sigla TEXT NOT NULL UNIQUE
);

CREATE TABLE candidato (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombres TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    partido_id INTEGER NOT NULL REFERENCES partido(id)
);

CREATE TABLE eleccion (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo TEXT NOT NULL,
    fecha TEXT NOT NULL
);

CREATE TABLE resultado (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    eleccion_id INTEGER NOT NULL REFERENCES eleccion(id),
    candidato_id INTEGER NOT NULL REFERENCES candidato(id),
    mesa_id INTEGER NOT NULL REFERENCES mesa(id),
    votos INTEGER NOT NULL
);

-- ===========================
-- 2. INSERCIÓN DE DATOS
-- ===========================

-- Departamentos (10)
INSERT INTO departamento (nombre) VALUES
('Antioquia'), ('Cundinamarca'), ('Atlántico'),
('Santander'), ('Valle del Cauca'), ('Tolima'),
('Nariño'), ('Boyacá'), ('Cesar'), ('Bolívar');

-- Municipios (30)
INSERT INTO municipio (nombre, departamento_id) VALUES
('Medellín',1), ('Envigado',1), ('Bello',1),
('Bogotá',2), ('Chía',2), ('Soacha',2),
('Barranquilla',3), ('Soledad',3), ('Malambo',3),
('Bucaramanga',4), ('Floridablanca',4), ('Girón',4),
('Cali',5), ('Palmira',5), ('Yumbo',5),
('Ibagué',6), ('Espinal',6), ('Melgar',6),
('Pasto',7), ('Ipiales',7), ('Tumaco',7),
('Tunja',8), ('Duitama',8), ('Sogamoso',8),
('Valledupar',9), ('Aguachica',9), ('Bosconia',9),
('Cartagena',10), ('Turbaco',10), ('Arjona',10);

-- Puestos (15)
INSERT INTO puesto (nombre, direccion, municipio_id) VALUES
('Colegio San José','Cra 45 #12-30',1),
('Colegio Envigado','Calle 34 #20-15',2),
('Colegio Bello Norte','Calle 55 #44-12',3),
('Instituto Central','Av 68 #45-20',4),
('Colegio Chía Centro','Cra 10 #8-22',5),
('Colegio Soacha Sur','Calle 12 #4-55',6),
('Liceo del Caribe','Calle 72 #45-10',7),
('Colegio Soledad Real','Calle 45 #20-22',8),
('Colegio Malambo','Cra 50 #30-18',9),
('Colegio Santander','Cra 15 #32-10',10),
('Colegio Floridablanca','Calle 29 #10-07',11),
('Colegio Girón','Calle 5 #11-22',12),
('Colegio Cali Norte','Av 4N #56-10',13),
('Colegio Palmira','Cra 31 #25-14',14),
('Colegio Yumbo','Calle 10 #20-55',15);

-- Mesas (3 por puesto → 45 mesas)
INSERT INTO mesa (numero, puesto_id)
SELECT n AS numero, p.id
FROM puesto p
CROSS JOIN (
    SELECT 1 AS n
    UNION ALL SELECT 2
    UNION ALL SELECT 3
);

-- Partidos (10)
INSERT INTO partido (nombre, sigla) VALUES
('Partido Liberal','PLC'),
('Centro Democrático','CD'),
('Partido Verde','PV'),
('Pacto Histórico','PH'),
('Cambio Radical','CR'),
('Partido Conservador','PC'),
('Alianza Social Independiente','ASI'),
('Partido de la U','PU'),
('Nuevo Liberalismo','NL'),
('Fuerza Ciudadana','FC');

-- Candidatos (20)
INSERT INTO candidato (nombres, apellidos, partido_id) VALUES
('Juan','Pérez',1), ('María','Gómez',2), ('Carlos','López',3),
('Ana','Rincón',4), ('Felipe','Suárez',5), ('Laura','Torres',6),
('Jorge','Mendoza',7), ('Daniela','Rojas',8), ('Santiago','Díaz',9),
('Valeria','Castro',10), ('Oscar','Arias',1), ('Natalia','Martínez',2),
('Luis','Ramírez',3), ('Paula','García',4), ('Tomás','Herrera',5),
('Carmen','Benítez',6), ('Sofía','Rivas',7), ('Andrés','Quintero',8),
('Elena','Vargas',9), ('Ricardo','Ortega',10);

-- Elección
INSERT INTO eleccion (tipo, fecha) VALUES
('Presidencial','2022-05-29');

-- Resultados (45 mesas × 20 candidatos = 900 registros)
INSERT INTO resultado (eleccion_id, candidato_id, mesa_id, votos)
SELECT 
    1,
    c.id,
    m.id,
    ABS(RANDOM() % 350) + 30   -- votos entre 30 y 380
FROM candidato c
CROSS JOIN mesa m;