use paymentdb;
-- Registro de tablas relacionado con localizacion

INSERT INTO payment_Currencies
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
(4, '2023-10-01 14:00:00', NULL, 22.3015, TRUE, TRUE, 1, 6),
(5, now(), NULL, 540, TRUE, TRUE, 1, 7),
(6, now(), NULL, 0.0019, TRUE, TRUE, 7, 1);

select * from payment_ExchangeRates;


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

select * from payment_AuthPlatforms;

INSERT INTO payment_AuthSessions (sessionId, externalUser, token, refreshToken, lastUpdate, FK_authPlatformId)
VALUES
('session-12345', 'user-001', UNHEX('1234567890ABCDEF'), UNHEX('0987654321FEDCBA'), '2025-03-21 10:00:00', 1),
('session-67890', 'user-002', UNHEX('A1B2C3D4E5F67890'), UNHEX('0FEDCBA987654321'), '2025-03-21 11:00:00', 2);

select * from payment_AuthSessions;

-- Subscriptions

INSERT INTO `paymentdb`.`payment_subscriptions` (`subscriptionId`,`description`)
VALUES 
(0, 'None'),
(1, 'Basic'),
(2, 'Pro'),
(3, 'Premium');

INSERT INTO `paymentdb`.`payment_planPrices` (`planPriceId`,`amount`,`recurrencyType`,`postTime`,`FK_subscriptionId`,`FK_currencyId`)
VALUES 
(0, 0.00,'mensual',now(),0,1),
(1, 3.99,'mensual',now(),1,1),
(2, 9.99,'mensual',now(), 2,1),
(3, 19.99,'mensual',now(),3,1);


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

call InsertAuthSessions();

select * from payment_AuthSessions;

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
select * from payment_users;

-- Insercion de roles
INSERT INTO payment_roles(roleId, name)
VALUES(1,"Usuario"), (2,"Administrador");

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

-- INFORMACION DE CONTACTO

INSERT INTO payment_contactInfoTypes(contactInfoTypeId, name)
VALUES (1,"Email"),(2,"Numero Telefonico");

-- Informacion de contacto a los usuarios se enlaza el EMAIL

DELIMITER //

CREATE PROCEDURE insertEmails()
BEGIN

	SET @i = 1;
    
    WHILE @i <=31 DO
    
		-- Declaro variables locales
        SET @firstName = '';
        SET @lastName = '';
        SET @userId = 0;
        
        
        -- Selecciono  payment_users
        SELECT firstName, lastName, userId 
        INTO @firstName, @lastName, @userId
        FROM payment_users p 
        WHERE userId = @i;
        
        -- Creo el email
        SET @email=CONCAT(@firstname,".",@lastname,".",@i,"@gmail.com");
        
        INSERT INTO payment_contactsUserInfo(value,lastUpdate,enabled,FK_contactInfoTypesId,FK_userId)
        VALUES(@email,now(),1,1,@i);
    
		SET @i = @i+1;
    END WHILE;

END//

DELIMITER ;

call insertEmails();

SELECT * FROM payment_contactServiceInfo;


-- Insercion de modulos
INSERT INTO payment_modules(name)
VALUES("Pagos");

-- ---------------------------------------INSERCION DE TABLAS RELACIONADAS CON SERVICIOS ----------------------------------------------------
INSERT INTO payment_serviceCategories (serviceCategoryId,name)
VALUES(1,"Electricidad"),(2,"Transferencia"),(3,"Suscripciones");

-- servicios disponibles en la aplicacion
INSERT INTO payment_services (FK_serviceCategoryId, logoURL) 
VALUES
(1, 'https://example.com/ice_logo.jpg'),
(1, 'https://example.com/cfe_logo.jpg'),
(2, 'https://example.com/sinpe_movimiento_logo.jpg'),
(3, 'https://example.com/netflix_cr_logo.jpg');


-- Informacion de contacto de los servicios
INSERT INTO payment_contactServiceInfo (contactServiceInfoId, value, lastUpdate, enabled, FK_countryId, FK_serviceId, FK_contactInfoTypeId)
VALUES
(1, 'servicio@electricidad.cr', NOW(), 1, 1, 1, 1),
(2, '506-1234-5678', NOW(), 1, 1, 2, 2),
(3, 'suscripcion@netflix.cr', NOW(), 1, 2, 3, 1),
(4, '506-9876-5432', NOW(), 1, 3, 1, 2);

-- Transactions

INSERT INTO `paymentdb`.`payment_transTypes` (`transTypeId`,`name`)
VALUES 
(1, 'Debit'),
(2, 'Credit'),
(3, 'Transfer'),
(4, 'Card Payment'),
(5, 'Cash Payment'),
(6, 'Digital Wallet'),
(7, 'Cryptocurrency'),
(8, 'Refund');

select transTypeId, name, deleted from payment_transTypes;

INSERT INTO `paymentdb`.`payment_trasnSubTypes` (`transSubTypeId`,`name`)
VALUES 
(1, 'Subscription'),
(2, 'Cashback'),
(3, 'Claim Approved'),
(4, 'Claim Denied'),
(5, 'Recurring Payment'),
(6, 'Chargeback'),
(7, 'Partial Refund'),
(8, 'Total Refund');

select transSubTypeId, name, deleted from payment_trasnSubTypes;

DELIMITER //

CREATE PROCEDURE InsertTransactions()
BEGIN
	SET @cantUsuarios = 0;
	SET @j = 2;
    
    WHILE @j < 30 DO

	    SET @i =0;
		SET @FK_userId = 1; 
		SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @j;

		WHILE @i <= 5 DO                    -- se crean 10 transacciones para cada usuario
		
			-- Declaracion de variables para la transaccion
			SET @amount = RAND() * 200;
			SET @postTime = DATE_ADD(now(), INTERVAL FLOOR(RAND() * 20) MINUTE); -- el tiempo que haya tardado en ejecutar la transaccion
			SET @refNumber =                                                     -- un codigo de referencia debera verse tal que asi: AB123456789
			CONCAT(CHAR(FLOOR(65 + RAND() * 26)), 
			CHAR(FLOOR(65 + RAND() * 26)),
			FLOOR(100000000 + RAND() * 999999999));
            SET @FK_personId = FLOOR(2 + RAND() * 30);
			SET @checksum = SHA2(CONCAT(@amount, NOW(), @postTime,@refNumber,@FK_userId,@Fk_personId), 512);

			INSERT INTO payment_transactions (amount, transDateTime, postTime, refNumber, description, FK_userId, FK_personId, FK_exchangeRateid, FK_transSubTypeId, FK_transTypeId, checksum)
			VALUES 
			(@amount, NOW(), @postTime, @refNumber, '[Descripcion de la transaccion]', 
			@FK_userId, 
			@FK_personId,
			FLOOR(RAND() * 4),                 -- exchange rate
			FLOOR(1 + (RAND() * 8)),           -- transSubType ID
			FLOOR(1 + (RAND() * 8)),           -- transType ID
            @checksum);          
			
			SET @i = @i + 1;
		END WHILE;
        
        SET @j = @j +1;
	END WHILE;
END //

DELIMITER ;

call InsertTransactions();
select * from payment_transactions;
