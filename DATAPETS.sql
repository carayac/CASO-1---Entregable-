use petsdb;
select * from pets_countries;

INSERT INTO `petsdb`.`pets_countries`  
VALUES 
(1,'Panama', 'US Dollar', '$', 'ES');

INSERT INTO `petsdb`.`pets_countries` (`currencySymbol`, `language`, `name`, `currency`)  
VALUES 
('$', 'ES', "Canada", "CAN");

INSERT INTO `petsdb`.`pets_countries` (`name`, `currency`, `currencySymbol`, `language`) 
VALUES 
('United States', 'US Dollar', '$', 'EN'),
('France', 'Euro', '€', 'FR'),
('Japan', 'Japanese Yen', '¥', 'JA');


INSERT INTO `petsdb`.`pets_countries`  
VALUES 
(120,'Costa Rica', 'CRC', 'CRC', 'ES');

INSERT INTO `petsdb`.`pets_countries` (`currencySymbol`, `language`, `name`, `currency`)  
VALUES 
('Y', 'JP', "Japan", "Yens");

select name, currency from pets_countries;
select * from pets_estates;
select * from pets_cities;

INSERT INTO pets_estates (name, countryid) VALUES
('Cartago', 120),
('Heredia', 120);

INSERT INTO pets_estates (name, countryid) VALUES
('Alajuela', 120) ;

INSERT INTO pets_cities (name, stateid) VALUES
('Los Angeles', 4),
('Tejar', 4),
('El Carmen', 8),
('Flores', 5),
('San Joaquin', 8);


INSERT INTO `petsdb`.`pets_addresses` (`line1`, `line2`, `zipcode`, `location`, `cityid`)
VALUES ('123 Main St', 'Apt 4B', '12345', ST_GeomFromText('POINT(40.7128 -74.0060)'), 11);

INSERT INTO `petsdb`.`pets_addresses` (`line1`, `line2`, `zipcode`, `location`, `cityid`)
VALUES ('123 Main St', 'Apt 4B', '12345', ST_GeomFromText('POINT(41.7128 -74.0060)'), 15);

select * from pets_addresses;

-- Insert 1
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('John', 'Doe', 'john.doe@example.com', 4);

-- Insert 2
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('Jane', 'Smith', 'jane.smith@example.com', 4);

-- Insert 3
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('Alice', 'Johnson', 'alice.johnson@example.com', 5);

-- Insert 4
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('Bob', 'Brown', 'bob.brown@example.com', 5);

-- Insert 5
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('Charlie', 'Davis', 'charlie.davis@example.com', 5);

-- Insert 6
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('Eva', 'Wilson', 'eva.wilson@example.com', 4);

-- Insert 7
INSERT INTO `petsdb`.`pets_owners` (`firstname`, `lastname`, `email`, `addressesid`)
VALUES ('Frank', 'Moore', 'frank.moore@example.com', 4);


-- Insert 1
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Buddy', 'Labrador', 3, 1);

-- Insert 2
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Max', 'German Shepherd', 5, 1);

-- Insert 3
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Bella', 'Golden Retriever', 2, 1);

-- Insert 4
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Charlie', 'Bulldog', 4, 1);

-- Insert 5
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Lucy', 'Poodle', 6, 1);

-- Insert 6
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Daisy', 'Beagle', 1, 1);

-- Insert 7
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Molly', 'Rottweiler', 7, 1);

-- Insert 8
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Bailey', 'Boxer', 3, 1);

-- Insert 9
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Lola', 'Dachshund', 2, 1);

-- Insert 10
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Rocky', 'Siberian Husky', 4, 1);

-- Insert 11
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Coco', 'Chihuahua', 1, 1);

-- Insert 12
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Milo', 'Shih Tzu', 5, 1);

-- Insert 13
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Sophie', 'Pug', 3, 1);

-- Insert 14
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Duke', 'Great Dane', 2, 1);

-- Insert 15
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Luna', 'Border Collie', 4, 1);

-- Insert 16
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Zoe', 'Yorkshire Terrier', 1, 1);

-- Insert 17
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Toby', 'Australian Shepherd', 3, 1);

-- Insert 18
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Oscar', 'French Bulldog', 2, 2);

-- Insert 19
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Ruby', 'Cocker Spaniel', 5, 2);

-- Insert 20
INSERT INTO `petsdb`.`pets_pets` (`name`, `race`, `age`, `status`)
VALUES ('Leo', 'Pomeranian', 1, 2);

INSERT INTO pets_petowners (ownerid, petid) 
SELECT * from pets_pets;
select * from pets_addresses;
select * from pets_petowners;
select * from pets_owners;
update pets_owners SET addressesid = 4 WHERE ownerid>15;
update pets_petowners SET ownerid = 13 WHERE petid >10;
update pets_petowners SET ownerid = 4 WHERE petid IN (5, 10);
update pets_petowners SET ownerid = 5 WHERE petid IN (20);
update pets_petowners SET ownerid = 6 WHERE petid IN (17, 13, 8);
update pets_petowners SET ownerid = 7 WHERE petid = 40;

select * from pets_owners ORDER BY lastname;
select * from pets_owners ORDER BY lastname ASC;
select * from pets_owners ORDER BY lastname DESC;

select * from pets_owners ORDER BY lastname, firstname DESC;

SELECT @countVisits;

select RAND();
select *,RAND() from pets_petowners;

DROP PROCEDURE LlenarDeVisitas;
DELIMITER //

CREATE PROCEDURE LlenarDeVisitas()
BEGIN
	SET @countVisits = 1000;

	WHILE @countVisits > 0 DO
		-- User-defined variable in a session
		SET @ownerid = 1;
		SET @petid = 1;

		SELECT ownerid, petid from pets_petowners ORDER BY RAND() limit 1 INTO @ownerid, @petid;

		-- Declarar la variable para almacenar la fecha y hora aleatoria
		SET @starttime = NULL;
		-- Generar una fecha y hora aleatoria dentro del rango especificado
		SET @starttime = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 200) DAY); -- Fecha aleatoria en los últimos 200 días
		SET @starttime = DATE_ADD(DATE(@starttime), INTERVAL FLOOR(8 + RAND() * 9) HOUR); -- Hora entre 8 AM y 5 PM
		SET @starttime = DATE_ADD(@starttime, INTERVAL FLOOR(RAND() * 60) MINUTE); -- Minutos aleatorios (0-59)

		-- Declarar la variable para almacenar la nueva fecha
		SET @endtime = NULL;
		-- Agregar un número aleatorio de minutos entre 15 y 130
		SET @endtime = DATE_ADD(@starttime, INTERVAL FLOOR(15 + RAND() * 116) MINUTE);

		SET @vetname = NULL;
		SET @condicion = NULL;
		SELECT ELT(FLOOR(1 + RAND() * 4), 'patitas vet', 'mi mascota', 'uñitas', 'maskotitas') INTO @vetname;
		SELECT ELT(FLOOR(1 + RAND() * 6), 'fiebre', 'infección', 'sano', 'sarro', 'virus estomacal', 'dolor muscular') INTO @condicion;

		INSERT INTO pets_visits (starttime, endtime, description, vetname, `condition`, ownerid, petid)
		VALUES (@starttime, @endtime, 'Esto es la descripcion', @vetname, @condicion, @ownerid, @petid);

		SET @countVisits = @countVisits - 1;
	END WHILE ;
END //

DELIMITER ;

call LlenarDeVisitas();

select * from pets_visits;

select * from pets_countries C, pets_estates E
WHERE C.countryid = E.countryid;

select c.*, e.* from pets_countries c, pets_estates e
WHERE c.countryid = e.countryid and c.currency >10000



-- fields projection, en el projection puedo renombrar los campos
select starttime, description, vetname, `condition` from pets_visits;

-- renombrando el nombre de las columnas
select starttime inicio, description descripcion, vetname veterinaria, `condition` salud from pets_visits;

select starttime inicio, MONTHNAME(starttime), DAYNAME(starttime),
description descripcion, vetname veterinaria, `condition` salud from pets_visits;

-- renombrado
select starttime inicio, MONTHNAME(starttime) mes, DAYNAME(starttime) dia,
description descripcion, vetname veterinaria, `condition` salud from pets_visits;


-- este campo artificial que se crea , que no existe en la tabla pero se calcula
-- dinámicamente le llamos "CALCULATED FIELD"
select starttime inicio, MONTHNAME(starttime) mes, DAYNAME(starttime) dia, 
CASE 
	WHEN MONTH(starttime)<4 THEN 'Primer Trimestre' 
    WHEN MONTH(starttime)>3 AND MONTH(starttime)<7  THEN 'Segundo Trimestre' 
    WHEN MONTH(starttime)>6 AND MONTH(starttime)<10  THEN 'Tercer Trimestre' 
    ELSE 'Cuarto Trimestre' 
END AS Trimestre,
description descripcion, vetname veterinaria, `condition` salud from pets_visits;

select starttime inicio, MONTHNAME(starttime) mes, DAYNAME(starttime) dia, 
ELT((CEIL(MONTH(starttime)/3)), 'Primer Trimestre', 'Segundo Trimestre', 'Tercer Trimestre', 'Cuarto Trimestre') as Trimestre,
description descripcion, vetname veterinaria, `condition` salud from pets_visits;

select starttime inicio, MONTHNAME(starttime) mes, DAYNAME(starttime) dia, 
ELT(QUARTER(starttime), 'Primer Trimestre', 'Segundo Trimestre', 'Tercer Trimestre', 'Cuarto Trimestre') as Trimestre,
description descripcion, vetname veterinaria, `condition` salud from pets_visits;

SELECT starttime, TIMESTAMPDIFF(MINUTE,starttime, endtime) TiempoDeConsulta,
vetname veterinaria, `condition` estadoDeLaMascota
FROM pets_visits
INNER JOIN pets_pets ON pets_visits.petid = pets_pets.petid;

SELECT starttime, TIMESTAMPDIFF(MINUTE,starttime, endtime) TiempoDeConsulta,
vetname veterinaria, `condition` estadoDeLaMascota
FROM pets_visits visits
INNER JOIN pets_pets pets ON visits.petid = pets.petid;


SELECT visits.*, pets.*
FROM pets_visits visits
INNER JOIN pets_pets pets ON visits.petid = pets.petid;

-- saco todas las visitas de las mascotas con su respectivo nombre
SELECT starttime, TIMESTAMPDIFF(MINUTE,starttime, endtime) TiempoDeConsulta,
vetname veterinaria, pets.name, pets.race, `condition` estadoDeLaMascota
FROM pets_visits visits
INNER JOIN pets_pets pets ON visits.petid = pets.petid;

-- saco todas las visitas de las mascotas con su respectivo nombre para una mascota especifica
-- en orden de visita
SELECT starttime, TIMESTAMPDIFF(MINUTE,starttime, endtime) TiempoDeConsulta,
vetname veterinaria, pets.name, pets.race, `condition` estadoDeLaMascota
FROM pets_visits visits
INNER JOIN pets_pets pets ON visits.petid = pets.petid
WHERE pets.name = 'Sophie' ORDER BY starttime ASC;

-- saco todas las visitas de las mascotas con su respectivo nombre para una mascota especifica
-- en orden de visita, incluyendo el nombre del dueño
SELECT starttime, TIMESTAMPDIFF(MINUTE,starttime, endtime) TiempoDeConsulta,
vetname veterinaria, pets.name, pets.race, CONCAT(owners.firstname, " ", owners.lastname) dueno, 
`condition` estadoDeLaMascota
FROM pets_visits visits
INNER JOIN pets_pets pets ON visits.petid = pets.petid
INNER JOIN pets_owners owners ON visits.ownerid = owners.ownerid
WHERE pets.name = 'Sophie' ORDER BY starttime ASC;


SELECT COUNT(1) from pets_visits; -- funcion agregada de count
-- se le llaman agregadas porque van agregando datos a subconjuntos 

SELECT MIN(starttime), MAX(starttime), MAX(vetname) from pets_visits; 

-- no quiero ver el total de visitas , si no que quiero saber el total de visitas por mascota, quiero saber cual 
-- es la mascota mas enfermiza
SELECT COUNT(1), petid from pets_visits
group by petid ORDER BY COUNT(1) DESC;

SELECT COUNT(1), pets.name from pets_visits
INNER JOIN pets_pets pets ON pets_visits.petid = pets.petid
group by pets_visits.petid ORDER BY COUNT(1) DESC;

SELECT COUNT(1) visits, pets.name from pets_visits
INNER JOIN pets_pets pets ON pets_visits.petid = pets.petid
group by pets.name ORDER BY COUNT(*) DESC;

select COUNT(petid) from pets_visits;
select * from pets_pets where status = 2;

select AVG(age), race from pets_pets group by race;
-- sacar las razas en status = 2, y el average por race

select * from pets_petowners;


update pets_petowners SET ownerid = 17 WHERE petid>31;

SELECT c.cityid, c.name AS city_name, COUNT(v.petid) total_visitas
FROM pets_visits v
INNER JOIN pets_owners o ON v.ownerid = o.ownerid
INNER JOIN pets_addresses a ON o.addressesid = a.addressesid
INNER JOIN pets_cities c ON a.cityid = c.cityid
GROUP BY c.cityid, c.name
ORDER BY total_visitas DESC
LIMIT 1;

select min(visitid), max(visitid) from pets_visits;
select sha2("hello", 512);

SELECT o.firstname, o.lastname,
       CASE 
           WHEN SUM(CASE WHEN p.racesize = 'large' THEN 1 ELSE 0 END) > 
                SUM(CASE WHEN p.racesize = 'small' THEN 1 ELSE 0 END)
           THEN 'large'
           ELSE 'small'
       END  space
FROM pets_owners o
INNER JOIN pets_petowners po ON o.ownerid = po.ownerid
INNER JOIN pets_pets p ON po.petid = p.petid
GROUP BY o.ownerid, o.firstname, o.lastname;

ALTER TABLE pets_pets ADD COLUMN racesize VARCHAR(10) NOT NULL DEFAULT("large");

ALTER TABLE pets_visits ADD COLUMN Amount DECIMAL(10,2)