use paymentdb;
-- Registro de tablas relacionado con localizacion

INSERT INTO `paymentdb`.`payment_Currencies` 
VALUES 
(1,'US Dollar', 'USD', '$'),
(2,'Euro', 'EUR', '€'),
(3,'British Pound Sterling', 'GBP', '£'),
(4,'Japanese Yen', 'JPY', '¥'),
(5,'Mexican Peso', 'MXN', '$'),
(6,'Russian Ruble', 'RUB', '₽'),
(7, 'Costa Rican Colon', 'CRC', '₡');


INSERT INTO payment_ExchangeRates (`exchangeRateid`, `startDate`, `endDate`, `exchangerate`, `enable`, `currentexchangerate`, `FK_currencyIdsource`, `FK_currencyIdDestiny`) VALUES 
(0, '2023-08-01 10:00:00', NULL, 19.5478, TRUE, TRUE, 1, 2),
(1, '2023-07-01 09:00:00', '2023-12-01 09:00:00', 0.83, TRUE, FALSE, 2, 3),
(2, '2023-09-15 08:00:00', NULL, 74.9832, TRUE, TRUE, 1, 4),
(3, '2023-06-01 11:30:00', '2023-11-01 11:30:00', 0.7365, TRUE, FALSE, 1, 5),
(4, '2023-10-01 14:00:00', NULL, 22.3015, TRUE, TRUE, 1, 6);


INSERT INTO `paymentdb`.`payment_Countries` (`countryId`,`FK_currencyId`,`name`,`phoneCode`)
VALUES 
(1, 1, 'United States', '+1'),
(2, 2, 'France', '+33'),
(3, 2, 'Spain', '+34'),
(4, 4, 'Japan', '+81'),
(5, 5, 'Mexico', '+52'),
(6, 6, 'Russia', '+7'),
(7, 7, 'Costa Rica', '+506');

-- Auth Sessions
INSERT INTO payment_AuthPlatforms (authPlatformId, name, secretKey, `key`, logoURL)
VALUES
(1, 'Platform A', UNHEX('ABCDEF1234567890ABCDEF1234567890'), UNHEX('1234567890ABCDEF0987654321'), 'https://example.com/logoA.png'),
(2, 'Platform B', UNHEX('1234567890ABCDEF1234567890ABCDEF'), UNHEX('0987654321FEDCBA1234567890'), 'https://example.com/logoB.png');


INSERT INTO payment_AuthSessions (sessionId, externalUser, token, refreshToken, lastUpdate, FK_authPlatformId)
VALUES
('session-12345', 'user-001', UNHEX('1234567890ABCDEF'), UNHEX('0987654321FEDCBA'), '2025-03-21 10:00:00', 1),
('session-67890', 'user-002', UNHEX('A1B2C3D4E5F67890'), UNHEX('0FEDCBA987654321'), '2025-03-21 11:00:00', 2);


-- procedimiento que inserta datos de sesiones de autenticacion esto para cada usuario

DELIMITER //

CREATE PROCEDURE InsertAuthSessions()
BEGIN

	SET @i=3;
    WHILE @i<=30 DO
    
		SET @session = CONCAT("session-",@i);
        SET @externalUser = CONCAT("user-00",@i);
        SET @lastUpdate = DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 100) DAY);
        
		SET @token = CONCAT(
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0')
		);
        SET @refreshToken = CONCAT(
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0'),
			LPAD(HEX(FLOOR(RAND() * 255)), 2, '0')
		);
        
        INSERT INTO payment_AuthSessions (sessionId, externalUser, token, refreshToken, lastUpdate, FK_authPlatformId)
        VALUES (@session,@externalUser,UNHEX(@token),UNHEX(@refreshToken),@lastUpdate, FLOOR(1 + (RAND() * 2)));
		
		SET @i = @i+1;
    END WHILE;

END//

DELIMITER ;


-- Procedimiento que inserta 30 usuarios a la base de datos por medio de datos aleatorias

DELIMITER //

CREATE PROCEDURE InsertPaymentUsers()
BEGIN
    SET @i =0;
    
    WHILE @i <= 30 DO
    
		-- Declaro variables que almacenan el nombre y apellido
		SET @firstName = "";
        SET @lastName = "";
        SET @birthdate = DATE_ADD('1980-01-01', INTERVAL FLOOR(RAND() * 7300) DAY);
		SET @password = CONCAT(
			CHAR(FLOOR(65 + RAND() * 26)),  -- Letra aleatoria mayúscula
			CHAR(FLOOR(65 + RAND() * 26)),  -- Letra aleatoria mayúscula
			CHAR(FLOOR(97 + RAND() * 26)),  -- Letra aleatoria minúscula
			CHAR(FLOOR(97 + RAND() * 26)),  -- Letra aleatoria minúscula
			FLOOR(0 + RAND() * 10),         -- Dígito aleatorio
			FLOOR(0 + RAND() * 10),         -- Dígito aleatorio
			CHAR(FLOOR(33 + RAND() * 15))   -- Carácter especial
		);
        
        -- Escoje de forma aleatoria el nombre y apellido del usuario
        -- lista de nombres de personas
        -- Selección aleatoria del primer nombre y apellido
        SET @firstName = ELT(FLOOR(1 + RAND() * 30), 'Juan', 'Ana', 'Carlos', 'María', 'Luis', 'Pedro', 'Marta', 'Javier', 'Lucía', 'José', 'Roberto', 'Laura', 'David', 'Sofía', 'Francisco', 'Paula', 'Andrés', 'Isabel', 'Fernando', 'Elena', 'Ricardo', 'Rosa', 'Alejandro', 'Beatriz', 'Tomás', 'Cristina', 'Miguel', 'Carmen', 'Eduardo', 'Patricia', 'Antonio');
        SET @lastName = ELT(FLOOR(1 + RAND() * 30), 'González', 'Rodríguez', 'Pérez', 'Martínez', 'López', 'Sánchez', 'García', 'Fernández', 'Díaz', 'Romero', 'Ruiz', 'Hernández', 'Jiménez', 'Morales', 'Alonso', 'Vargas', 'Sánchez', 'Torres', 'Flores', 'Díaz', 'Castro', 'Mendoza', 'Gómez', 'Ramírez', 'Álvarez', 'Delgado', 'Ruiz', 'Navarro', 'Molina', 'Ramos', 'Castillo');
        

        
		INSERT INTO payment_users (firstName, lastName, password, birthdate, enabled, FK_countryId, FK_authSessionId)
        VALUES 
        (@firstName, 
         @lastName, 
         @password, 
         @birthdate, 
         1,  -- enabled = 1
         FLOOR(1 + (RAND() * 7)),  -- FK_countryId aleatorio entre 1 y 7
         FLOOR(1 + (RAND() * 2)));  -- FK_authSessionId aleatorio entre 1 y 2
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call InsertPaymentUsers();

-- Insercion de roles
INSERT INTO payment_roles(roleId, name)
VALUES(1,"Usuario"), (2,"Administrador")

-- Insercion de roles de usuario

DELIMITER //

CREATE PROCEDURE insertUserRoles()
BEGIN
    SET @i = 1;
    
    WHILE @i <= 31 DO
        -- Declaro variables locales
        SET @firstName = '';
        SET @lastName = '';
        SET @userId = 0;
        
        -- Selecciono  payment_users
        SELECT firstName, lastName, userId 
        INTO @firstName, @lastName, @userId
        FROM payment_users p 
        WHERE userId = @i;
        
        -- Concateno los datos para generar un username
        SET @username = CONCAT(@firstName, @lastName, @i);
        
        -- Cchecksum
        SET @checksum = SHA2(CONCAT(@username, NOW(), @userId), 512);
        
        -- Inserto el nuevo registro en payment_userRoles
        INSERT INTO payment_userRoles(userId, username, lastUpdate, checksum, enabled, deleted, FK_roleId)
        VALUES (@userId, @username, NOW(), @checksum, 1, 0, 1);
        
        SET @i = @i + 1;
    END WHILE;
END//

DELIMITER ;

call insertUserRoles();

select * from payment_userRoles
