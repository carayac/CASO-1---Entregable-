use paymentdb;

-- Archivo de llenado de datos
-- Entregable 2 - Caso 1
-- Estudiantes:
-- Carol Daniela Araya Conejo – 2024089174
-- Lindsay Nahome Marín Sánchez – 2024163904

-- --------------------------------------- TABLAS RELACIONADAS CON LOCALIZACION ---------------------------------------

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

INSERT INTO `paymentdb`.`payment_Countries` (`countryId`,`FK_currencyId`,`name`,`phoneCode`)
VALUES 
(1, 1, 'United States', '+1'),
(2, 2, 'France', '+33'),
(3, 2, 'Spain', '+34'),
(4, 4, 'Japan', '+81'),
(5, 5, 'Mexico', '+52'),
(6, 6, 'Russia', '+7'),
(7, 7, 'Costa Rica', '+506');

-- --------------------------------------- TABLAS RELACIONADAS CON SESIONES ---------------------------------------

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

call InsertAuthSessions();

-- --------------------------------------- TABLAS RELACIONADAS CON MODULOS ----------------------------------------------------

-- Insercion de modulos
INSERT INTO payment_modules(name)
VALUES("Pagos");

-- --------------------------------------- TABLAS RELACIONADAS CON USUARIOS ----------------------------------------------------

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

-- --------------------------------------- TABLAS RELACIONADAS CON SERVICIOS ----------------------------------------------------

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

-- --------------------------------------- TABLAS RELACIONADAS CON TRANSACCIONES ---------------------------------------

-- Tipos de transacciones para detectar el tipo del pago
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

-- Subtipos de transacciones para identificar el motivo del pago
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

DELIMITER //
-- Procedimiento para agregar una variedad de transacciones para cada usuario
CREATE PROCEDURE InsertTransactions()
BEGIN
	SET @j = 0;
    
    WHILE @j < 30 DO

	    SET @i =0;
		SET @FK_userId = 1; 
		SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @j;

		WHILE @i <= 8 DO                    -- se crean 8 transacciones para cada usuario
		
			-- Declaracion de variables para la transaccion
			SET @amount = RAND() * 200;
			SET @postTime = DATE_ADD(now(), INTERVAL FLOOR(RAND() * 20) MINUTE); -- el tiempo que haya tardado en ejecutar la transaccion
			SET @refNumber =                                                     -- un codigo de referencia debera verse tal que asi: AB123456789
			CONCAT(CHAR(FLOOR(65 + RAND() * 26)),                                
			CHAR(FLOOR(65 + RAND() * 26)),
			FLOOR(100000000 + RAND() * 999999999));
            SET @FK_personId = FLOOR(1 + RAND() * 30);                               -- El userId del objetivo de la transaccion
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
-- SELECT * FROM payment_currencies;

SET FOREIGN_KEY_CHECKS = 0;
SELECT CONCAT('TRUNCATE TABLE ', table_name, ';') 
FROM information_schema.tables 
WHERE table_schema = 'paymentdb';
TRUNCATE TABLE payment_AIMessages;
TRUNCATE TABLE payment_AIModel;
TRUNCATE TABLE payment_AIpaymentData;
TRUNCATE TABLE payment_AIresponse;
TRUNCATE TABLE payment_AISetup;
TRUNCATE TABLE payment_audioFiles;
TRUNCATE TABLE payment_audioperuser;
TRUNCATE TABLE payment_audiosperAI;
TRUNCATE TABLE payment_AuthPlatforms;
TRUNCATE TABLE payment_AuthSessions;
TRUNCATE TABLE payment_AvailablePaymentMethods;
TRUNCATE TABLE payment_AvailablePaymentMethodsPerService;
TRUNCATE TABLE payment_AvailablePaymentMethodsPerUser;
TRUNCATE TABLE payment_businesses;
TRUNCATE TABLE payment_contactInfoTypes;
TRUNCATE TABLE payment_contactServiceInfo;
TRUNCATE TABLE payment_contactsUserInfo;
TRUNCATE TABLE payment_conversationStatus;
TRUNCATE TABLE payment_Countries;
TRUNCATE TABLE payment_Currencies;
TRUNCATE TABLE payment_eventTypes;
TRUNCATE TABLE payment_ExchangeRates;
TRUNCATE TABLE payment_featuresPerPlan;
TRUNCATE TABLE payment_historyconversations;
TRUNCATE TABLE payment_Languages;
TRUNCATE TABLE payment_Logs;
TRUNCATE TABLE payment_LogSeverity;
TRUNCATE TABLE payment_LogSources;
TRUNCATE TABLE payment_LogTypes;
TRUNCATE TABLE payment_messageTypes;
TRUNCATE TABLE payment_modules;
TRUNCATE TABLE payment_paymentAnalysisLogs;
TRUNCATE TABLE payment_paymentAttempts;
TRUNCATE TABLE payment_paymentmethods;
TRUNCATE TABLE payment_planFeatures;
TRUNCATE TABLE payment_planLimits;
TRUNCATE TABLE payment_planPrices;
TRUNCATE TABLE payment_plansPerUser;
TRUNCATE TABLE payment_reminders;
TRUNCATE TABLE payment_reminderTypes;
TRUNCATE TABLE payment_restrictions;
TRUNCATE TABLE payment_roles;
TRUNCATE TABLE payment_rolesrestrictions;
TRUNCATE TABLE payment_scheduleDetails;
TRUNCATE TABLE payment_scheduledPayments;
TRUNCATE TABLE payment_schedules;
TRUNCATE TABLE payment_serviceCategories;
TRUNCATE TABLE payment_services;
TRUNCATE TABLE payment_statusTypes;
TRUNCATE TABLE payment_subscriptions;
TRUNCATE TABLE payment_systemActionTypes;
TRUNCATE TABLE payment_transactions;
TRUNCATE TABLE payment_Transcriptions;
TRUNCATE TABLE payment_TranscriptionSegments;
TRUNCATE TABLE payment_Translations;
TRUNCATE TABLE payment_transTypes;
TRUNCATE TABLE payment_trasnSubTypes;
TRUNCATE TABLE payment_userRoles;
TRUNCATE TABLE payment_users;
TRUNCATE TABLE payment_usersrestrictions;
SET FOREIGN_KEY_CHECKS = 1;



-- --------------------------------------- TABLAS RELACIONADAS CON HORARIOS DE PAGO ---------------------------------------

DELIMITER //
-- Procedimiento para agregar los posibles horarios de pago
CREATE PROCEDURE InsertSchedules()
BEGIN
SET @i =1;
    
    WHILE @i < 60 DO                  -- se crea una variedad de horarios para trabajar

        INSERT INTO `paymentdb`.`payment_schedules` (`scheduleId`,`name`,`recurrencyType`)
		VALUES 
		(@i,'Primero del mes','mensual'),
		(@i+1,'Cada 1 de enero','anual'),
		(@i+2,'Cada 2 semanas','semanal');

        SET @i = @i + 3;
    END WHILE;
END //

DELIMITER ;

call InsertSchedules();

DELIMITER //
-- Procedimiento para agregar detalles de los posibles horarios de pago
CREATE PROCEDURE InsertScheduleDetails()
BEGIN
SET @i =1;
    
    WHILE @i < 61 DO
    
		-- Declaracion de variables
        SET @scheduleRecurrency = MOD(@i,3)+1;                                                     -- se asegura que siempre hayan horarios de todos los tipos
        SET @baseDate = DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 300) DAY);         -- primera fecha en que se agrega el horario de pago
        
        SELECT recurrencyType INTO @recurrencyType FROM payment_schedules WHERE scheduleId = @scheduleId;
        SELECT 30, 'MONTH' INTO @days, @datepart WHERE @scheduleRecurrency = 1; 
        SELECT 365, 'YEAR' INTO @days, @datepart WHERE @scheduleRecurrency = 2; 
        SELECT 14, 'WEEK' INTO @days, @datepart WHERE @scheduleRecurrency = 3; 
        
        SET @lastExec = DATE_ADD('2025-03-08', INTERVAL FLOOR(RAND() * 15) DAY);         -- ultima fecha en que se pago segun el horario
        SET @nextExec = DATE_ADD(@lastExec, INTERVAL @days DAY);                         -- siguiente fecha en que se pagara segun el horario
        
        INSERT INTO `paymentdb`.`payment_scheduleDetails` (`schedulesDetailsId`,`baseDate`,`datePart`, `lastExecute`, `nextExecute`, `FK_scheduleId`)
		VALUES 
		(@i,@baseDate, @datePart, @lastExec, @nextExec, @i);
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call InsertScheduleDetails();

DELIMITER //
-- Procedimiento para agregar pagos agendados para una suscripcion
CREATE PROCEDURE InsertScheduledPaymentSub()
BEGIN
SET @i =0;
    
    WHILE @i <= 30 DO
    
		-- Declaracion de variables
        SET @scheduleId = (FLOOR(RAND() * 20) * 3) + 3;        -- se elige uno de los horarios mensuales al ser una suscripcion (3,6,9...)
        SET @FK_userId = 0;  
        SET @FK_serviceId = FLOOR(1 + RAND() * 4);                   -- se elige alguno de los 4 servicios
		SET @amount = RAND() * 200;
        SET @currencyId = FLOOR(1 + RAND() * 7);                     -- se elige alguna de las 7 monedas
        
        SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @i;

		INSERT INTO payment_scheduledPayments (scheduleId, userId, serviceId, amount, currencyId)
        VALUES 
        (@scheduleId, @FK_userId, @FK_serviceId, @amount, @currencyId);  
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call InsertScheduledPaymentSub();

DELIMITER //
-- Procedimiento para agregar pagos agendados para pagos miscelaneos
CREATE PROCEDURE InsertScheduledPaymentPay()
BEGIN
SET @i =0;
    WHILE @i <= 30 DO
    
		-- Declaracion de variables
        SET @scheduleDetailsId = FLOOR(1+RAND() * 27);               -- se elige uno de los horarios
        SET @FK_userId = 0;  
        SET @FK_serviceId = FLOOR(1 + RAND() * 4);                   -- se elige alguno de los 4 servicios
		SET @amount = RAND() * 500;
        SET @currencyId = FLOOR(1 + RAND() * 7);                     -- se elige alguna de las 7 monedas
        
        SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @i;

	INSERT INTO payment_scheduledPayments (scheduleDetailsId, userId, serviceId, amount, currencyId)
        VALUES 
        (@scheduleDetailsId, @FK_userId, @FK_serviceId, @amount, @currencyId);  
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call InsertScheduledPaymentPay();

-- --------------------------------------- TABLAS RELACIONADAS CON SUSCRPCIONES ---------------------------------------

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

DELIMITER //
-- Procedimiento para asociar usuarios a un plan
CREATE PROCEDURE InsertPlanPerUser()
BEGIN
    SET @i =0;
    
    WHILE @i <= 30 DO
    
		-- Declaracion de variables
		SET @adquisitonDate = DATE_ADD('2025-03-01', INTERVAL FLOOR(RAND() * 23) DAY);
        SET @FK_userId = 0;        
        SET @FK_scheduledPaymentId = 0;
        
        SELECT userId INTO @userId FROM payment_users WHERE userId = @i;
        SELECT scheduledPaymentId INTO @scheduledPaymentId FROM payment_scheduledPayments WHERE userId = @i LIMIT 1;
        
		INSERT INTO payment_plansPerUser (adquisitionDate, FK_planPriceId, FK_scheduledPaymentId, FK_userId)
        VALUES 
        (NOW(), 
        FLOOR((RAND() * 3) + 1),             -- planPriceId de los 3 posibles planes de pago
        @scheduledPaymentId,  
		@userId);  
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

-- --------------------------------------- TABLAS RELACIONADAS CON LOGS ---------------------------------------

-- Tipos de logs
INSERT INTO payment_logTypes 
VALUES 
(1,'Login'),
(2,'Logout'),
(3,'Login failed'),
(4,'Change password'),
(5,'Disable restriction'),
(6,'Enable restriction'),
(7,'Record audio'),
(8,'Execute payment'),
(9,'Set up a bank account'),
(10,'Send notification');

-- Posibles fuentes de un log
INSERT INTO payment_logSources 
VALUES 
(1,'Database'),
(2,'Mobile app'),
(3,'Api server'),
(4,'Notification system');

-- Nivel de importancia de un log
INSERT INTO payment_logSeverity
VALUES 
(1,'Info'),
(2,'Warning'),
(3,'Error');

DELIMITER //
-- Procedimiento que añade Logs sobre Logins exitosos en el sistema
CREATE PROCEDURE InsertLogsLogin()
BEGIN
	SET @j = 0;
    
    WHILE @j < 30 DO

	    SET @i =0;
        SET @loginAmount = FLOOR(1 + RAND() * 12);     -- se crean entre 1 y 12 registros de login para cada usuario
		SET @FK_userId = 1; 
        SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @j;

		WHILE @i <= @loginAmount DO                    -- se crean un numero de logins aleatorios para cada usuario
		-- Declaracion de identifiers
			SET @firstName = '';
            SET @lastName = '';
            SET @username = '';
			
			SELECT firstName, lastName INTO @firstName, @lastName FROM payment_users WHERE userId = @j;
			SELECT username INTO @username FROM payment_userRoles WHERE userId = @j;
            
            SET @description = '[Login succesful]';
			SET @computer = CONCAT(@firstName, @lastName, 'PC');                    -- se crea un nombre para la PC
			SET @trace = '';
            SET @checksum = SHA2(CONCAT(@description, NOW(), @computer,@username,@userId,1,2,1), 512);
			
			INSERT INTO payment_Logs (description, posttime, computer, username, trace, referenceId1, checksum, FK_logTypeId, FK_logSourceId, FK_logSeverityId)
			VALUES 
			(@description, now(), @computer, @username, @trace, @userId, @checksum,
			 1,2,1);
			
			SET @i = @i + 1;
		END WHILE;
        SET @j = @j +1; 
	END WHILE;
END //

DELIMITER ;

call insertLogsLogin();

DELIMITER //
-- Procedimiento que añade Logs sobre pagos exitosos en el sistema
CREATE PROCEDURE InsertLogsPayment()
BEGIN
	SET @j = 0;
    
    WHILE @j < 30 DO

	    SET @i =0;
        SET @loginAmount = FLOOR(4 + RAND() * 20);     -- se crean entre 4 y 20 registros de pago para cada usuario
		SET @FK_userId = 1; 
        SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @j;

		WHILE @i <= @loginAmount DO                    -- se crean un numero de logins aleatorios para cada usuario
		-- Declaracion de identifiers
			SET @firstName = '';
            SET @lastName = '';
            SET @username = '';
            SET @personId = 0;
            SET @amount = 0.0;
			
			SELECT firstName, lastName INTO @firstName, @lastName FROM payment_users WHERE userId = @j;
			SELECT username INTO @username FROM payment_userRoles WHERE userId = @j;
            SELECT FK_personId, amount INTO @personId, @amount FROM payment_transactions WHERE FK_userId = @j LIMIT 1;
            
            SET @description = '[Payment executed]';
			SET @computer = CONCAT(@firstName, @lastName, 'PC');                    -- se crea un nombre para la PC
			SET @trace = '';
            SET @checksum = SHA2(CONCAT(@description, NOW(), @computer,@username,@userId,@personId,@amount, 7,3,1), 512);
			
            -- insercion a la tabla
			INSERT INTO payment_Logs (description, posttime, computer, username, trace, referenceId1, referenceId2, value1, checksum, FK_logTypeId, FK_logSourceId, FK_logSeverityId)
			VALUES 
			(@description, now(), @computer, @username, @trace, @userId, @personId, @amount, @checksum,
			 7,3,1);
			
			SET @i = @i + 1;
		END WHILE;
        SET @j = @j +1; 
	END WHILE;
END //

DELIMITER ;

call insertLogsPayment();

-- --------------------------------------- TABLAS RELACIONADAS CON AUDIOS ---------------------------------------

INSERT INTO payment_audioFiles (`audioURL`, `filename`) VALUES
('https://example.com/audio/payment_success.mp3', 'payment_success.mp3'),
('https://example.com/audio/payment_failed.mp3', 'payment_failed.mp3'),
('https://example.com/audio/notification_tone.mp3', 'notification_tone.mp3'),
('https://example.com/audio/user_message.wav', 'user_message.wav'),
('https://example.com/audio/system_alert.ogg', 'system_alert.ogg');

-- Procedimientos que guarda 200 audios los cuales forman parte de convesaciones
DELIMITER //

CREATE PROCEDURE insertaudio()
BEGIN

	SET @i=0;
    WHILE @i<300 DO
		
        SET @audioURL = ELT(FLOOR(1 + RAND() * 5), 'https://example.com/audio/payment_success', 'https://example.com/audio/payment_failed3', 'https://example.com/audio/notification_tone', 'https://example.com/audio/user_message', 'https://example.com/audio/system_alert');
        SET @filename = ELT(FLOOR(1 + RAND() * 5), 'payment_success', 'payment_failed', 'notification_tone', 'user_message', 'system_alert');
        
		SET @audioURL = CONCAT(@audioURL, @i,".mp3");
        SET @filename = CONCAT(@filename, @i,".mp3");
        
        INSERT INTO payment_audioFiles(audioURL, filename)
        VALUES(@audioURL, @filename);
        
		SET @i = @i + 1;
    
    END WHILE;


END//

DELIMITER ;

call insertaudio();

-- --------------------------------------- TABLAS RELACIONADAS CON ANALISIS DE IA ---------------------------------------
-- ANALISIS DE IA
INSERT INTO payment_messageTypes (`messageTypeId`, `name`) VALUES
(1, 'text'),
(2, 'image'),
(3, 'audio_input'),
(4, 'audio_output'),
(5, 'tap'),
(6, 'reaction'),
(7, 'file');

INSERT INTO payment_AIModel (`idAIModel`, `name`, `enable`) VALUES
(1, 'GPT-4-turbo', 1),
(2, 'GPT-4', 1),
(3, 'GPT-3.5-turbo', 1);

INSERT INTO payment_Languages (`languageId`, `name`, `culture`) VALUES
(1, 'English', 'en-US'),
(2, 'Spanish', 'es-ES'),
(3, 'French', 'fr-FR'),
(4, 'German', 'de-DE'),
(5, 'Japanese', 'ja-JP');

DELIMITER //


CREATE PROCEDURE insertTranscription()
BEGIN

	SET @i = 0;
    WHILE @i<300 do
    
		SET @duration = ROUND(1 + (RAND() * 60), 2);
		SET @FK_audioFileId = FLOOR(1 + RAND() * 299);
        SET @FK_languageId = FLOOR(1 + RAND() * 5);
        SET @idAIModel = FLOOR(1 + RAND() * 3); 
        
        SET @transcriptionText = CONCAT(
            CASE
                WHEN FLOOR(RAND() * 10) = 0 THEN 'Quiero agendar un pago para el próximo lunes.'
                WHEN FLOOR(RAND() * 10) = 1 THEN '¿Cuáles son los montos disponibles para realizar un pago?'
                WHEN FLOOR(RAND() * 10) = 2 THEN '¿Puedo programar un pago automático cada mes?'
                WHEN FLOOR(RAND() * 10) = 3 THEN 'Necesito verificar el saldo para agendar el pago.'
                WHEN FLOOR(RAND() * 10) = 4 THEN '¿Qué método de pago tengo disponible para este proceso?'
                WHEN FLOOR(RAND() * 10) = 5 THEN 'Quiero realizar un pago el día 10 del próximo mes.'
                WHEN FLOOR(RAND() * 10) = 6 THEN '¿Cuál es el monto mínimo para agendar un pago recurrente?'
                WHEN FLOOR(RAND() * 10) = 7 THEN '¿Es posible cancelar un pago agendado?'
                WHEN FLOOR(RAND() * 10) = 8 THEN 'Me gustaría programar pagos automáticos para todas mis suscripciones.'
                ELSE 'Quiero ver las opciones para configurar pagos automáticos de mis servicios.'
            END
        );
        
        INSERT INTO payment_Transcriptions (duration, text, FK_audioFIleId, FK_languageId, idAIModel)
        VALUES (@duration, @transcriptionText, @FK_audioFileId, @FK_languageId, @idAIModel);
		SET @i = @i +1;
    
    END WHILE;

END //

DELIMITER ;

call insertTranscription();

-- PROCEDIMIENTO QUE ALMACENA RESPUESTA DE LA IA
drop procedure insertiaresponse

DELIMITER //

CREATE PROCEDURE insertiaresponse()
BEGIN

	SET @i = 0;
    
    while @i < 300 do
		
		SET @idAIModel = FLOOR(1 + RAND() * 3); 
        SET @transcriptionId = FLOOR(1 + RAND() * 299);
        
        SET @previous_responseid = CASE
			WHEN @1 != 0 THEN @i - 1
			ELSE NULL
		END;
				
        -- GENERA UN REPSUESTA ANALIZADA POR LA IA DE FOMRA ALEATORIA
        SET @textOption = FLOOR(1 + RAND() * 10);  
		SET @actionOption = FLOOR(1 + RAND() * 3);  

		
		CASE @textOption
			WHEN 1 THEN
				SET @outputText = CONCAT('¡Todo listo! Su pago ha sido ', IF(RAND() > 0.5, 'exitoso', 'rechazado'), '. ', 
										IF(RAND() > 0.5, 'Revise su cuenta para ver los detalles.', 'Por favor, intente nuevamente más tarde.'));
			WHEN 2 THEN
				SET @outputText = CONCAT('Su solicitud de pago ha sido ', IF(RAND() > 0.5, 'procesada', 'recibida'), '. ', 
										'El proceso tomará ', ROUND(RAND() * 10 + 5, 2), ' minutos. ¿Desea recibir una notificación cuando se complete?');
			WHEN 3 THEN
				SET @outputText = CONCAT('¡Todo está listo! El pago de ', ROUND(RAND() * 500, 2), ' fue ', 
										IF(RAND() > 0.5, 'programado correctamente', 'falló debido a un error en el sistema'), '.');
			WHEN 4 THEN
				SET @outputText = CONCAT('¡Gran noticia! El pago ha sido ', IF(RAND() > 0.5, 'agendado para el 15 de abril', 'cancelado por motivos técnicos'), '.',
										' Su transacción fue realizada por un monto de $', ROUND(RAND() * 300, 2), '.');
			WHEN 5 THEN
				SET @outputText = CONCAT('El pago de ', ROUND(RAND() * 500, 2), ' ha sido ', 
										IF(RAND() > 0.5, 'exitoso', 'rechazado'), '. ', 
										'Por favor, verifique los detalles de su cuenta o intente más tarde.');
			WHEN 6 THEN
				SET @outputText = CONCAT('Ha ocurrido un inconveniente al procesar su pago de $', ROUND(RAND() * 300, 2), '. ',
										'¿Le gustaría realizar el pago nuevamente o contactar al soporte?');
			WHEN 7 THEN
				SET @outputText = CONCAT('El pago ha sido ', IF(RAND() > 0.5, 'confirmado', 'pendiente de aprobación'), '. ',
										'Estaremos notificándole el estado en breve. ¿Algo más en lo que pueda asistirte?');
			WHEN 8 THEN
				SET @outputText = CONCAT('El pago fue ', IF(RAND() > 0.5, 'realizado exitosamente', 'cancelado debido a un error en el proceso de pago'), '.',
										' Puede revisar el estado en su historial. ¿Quieres hacer algo más?');
			WHEN 9 THEN
				SET @outputText = CONCAT('La solicitud de pago ha sido ', IF(RAND() > 0.5, 'procesada con éxito', 'rechazada por falta de fondos'), '. ',
										'Su pago de $', ROUND(RAND() * 400, 2), ' está ', IF(RAND() > 0.5, 'en revisión', 'completado'), '.');
			WHEN 10 THEN
				SET @outputText = CONCAT('La transacción está ', IF(RAND() > 0.5, 'en proceso', 'pendiente'), '. ',
										'El pago se completará dentro de ', ROUND(RAND() * 10, 0), ' minutos. ¿Puedo ayudarte con algo más?');
		END CASE;
        
        CASE @actionOption
			WHEN 1 THEN
				SET @outputText = CONCAT(@outputText, ' ¿Deseas realizar otra operación de pago ahora?');
			WHEN 2 THEN
				SET @outputText = CONCAT(@outputText, ' Si tienes dudas, el soporte está disponible las 24 horas.');
			WHEN 3 THEN
				SET @outputText = CONCAT(@outputText, ' ¿Te gustaría guardar este pago en tus favoritos para consultas futuras?');
		END CASE;
        
        INSERT INTO payment_AIresponse (previous_responseid, outputText, transcriptionId, idAIModel)
		VALUES (@previous_responseid, @outputText, @transcriptionId, @idAIModel);
        
		SET @i = @i +1;
    
    END WHILE;

END//

DELIMITER ;

call insertiaresponse();

-- CONFIGURACION DE LA IA
INSERT INTO `paymentdb`.`payment_AISetup` 
(`callbackPost`, `temporaryKey`, `webSocketClient`, `authToken`, `openapiKey`) 
VALUES 
('https://api.example.com/callback', 45, 'ws://example.com/socket', 'abc123authToken', 'xyz456openApiKey');

-- PROCEDIMIENTO QUE LLENA AUDIOS GENERADOS A PARTIR DE UNA RESPUESTA DE IA


DELIMITER //

CREATE PROCEDURE insertaudioperAI()
BEGIN

	SET @i = 0;

	WHILE @i<300 DO
    
		SET @random_voice = 'female';
		SET @AIsetup = 1;
        SET @AIresponse_input = FLOOR(1 + RAND() * 299); 
        SET @expires_at = UNIX_TIMESTAMP(NOW()) + FLOOR(RAND() * 1000000);
        SET @idAIModel = FLOOR(1 + RAND() * 3);
        SET @audioFileId = FLOOR(1 + RAND() * 299);
        
        SET @format = CASE
            WHEN FLOOR(1 + RAND() * 3) = 1 THEN 'mp4'
            WHEN FLOOR(1 + RAND() * 3) = 2 THEN 'mp3'
            ELSE 'wav'
        END;
        
         INSERT INTO payment_audiosperAI
        (`voice`, `reponseformat`, `payment_idAISetup`, `FK_idAIresponse_input`, `index`, `expires_at`, `idAIModel`, `audioFIleId`)
        VALUES
        (@random_voice, @format, @AIsetup, @AIresponse_input, null,@expires_at, @idAIModel, @audioFileId);
        
		SET @i = @i +1;
    END WHILE;

END//

DELIMITER ;

call insertaudioperAI();

-- insert que representa los tipos de estados en la que puede estar una conversacion
INSERT INTO payment_conversationStatus (`idconversationStatus`, `name`) VALUES
(1, 'INICIO'),
(2, 'ESPERANDO_PAGO'),
(3, 'PROCESANDO_PAGO'),
(4, 'PAGO_EXITOSO'),
(5, 'PAGO_RECHAZADO'),
(6, 'AUTENTICACION'),
(7, 'FALLO_TELEFONICO'),
(8, 'CANCELADO'),
(9, 'ESPERE_INGRESO'),
(10, 'FINALIZADO');


-- PROC que permite almacenar las conversaciones que han sido generadas por la IA
DELIMITER //

CREATE PROCEDURE insertHistoryConversations()
BEGIN
    SET @i = 0;
    
    WHILE @i < 60 DO
        SET @userId = FLOOR(1 + RAND() * 31);
        SET @idAISetup = 1;
        SET @tokenQuantity = FLOOR(RAND() * 1000);
        SET @firstID = CONCAT('FIRST-', FLOOR(RAND() * 10000));
        SET @lastID = @firstID + 5;
        SET @finishReason = CASE 
            WHEN RAND() > 0.8 THEN 'Finished successfully with all tasks completed'
            WHEN RAND() > 0.6 THEN 'Finished successfully but with minor issues'
            WHEN RAND() > 0.4 THEN 'Finished successfully, but user encountered some difficulties'
            WHEN RAND() > 0.2 THEN 'Cancelled by user due to time constraints'
            ELSE 'Cancelled by user due to technical issues'
        END;
        SET @idconversationStatus = FLOOR(1 + RAND() * 10);
        SET @accuracyLevel = CONCAT(ROUND(RAND() * 100, 2), '%');

        INSERT INTO payment_historyconversations (userId, idAISetup, tokenQuantity, firstID, lastID, finishReason, idconversationStatus, accuracyLevel)
        VALUES (@userId, @idAISetup, @tokenQuantity, @firstID, @lastID, @finishReason, @idconversationStatus, @accuracyLevel);

        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call insertHistoryConversations();

-- PROC que asocia los mensajes a cada conversacion

DELIMITER //


CREATE PROCEDURE insertPaymentAIMessages()
BEGIN
		SET @i = 0;
		SET @idConversation = 1;

		WHILE @i < 300 DO

			SET @FK_messageTypeId = FLOOR(1 + RAND() * 7);
			SET @role = CASE 
							WHEN RAND() > 0.5 THEN 'user' 
							ELSE 'assistant' 
						END;
			SET @content = CONCAT(
							CASE 
								WHEN RAND() > 0.5 THEN 'Hello, how can I assist you today?'
								WHEN RAND() > 0.4 THEN 'I’m sorry, I didn’t quite catch that.'
								WHEN RAND() > 0.3 THEN 'Can you clarify your request, please?'
								WHEN RAND() > 0.2 THEN 'Please hold on while I process that.'
								ELSE 'Thank you for your patience, we are working on it.'
							END
						);
		
			SET @enabled = 1;
			SET @idconversations =  @idConversation;
			SET @promptTokens = FLOOR(RAND() * 200) + 1;
			SET @totalTokens = @promptTokens + FLOOR(RAND() * 100);
			SET @completionTokens = @totalTokens - @promptTokens;
			SET @transcriptionId = FLOOR(1 + RAND() * 298);
			SET @AIresponseId = FLOOR(2 + RAND() * 300);
			SET @idgenerateaudios = FLOOR(1 + RAND() * 298);

			SET @randomDays = FLOOR(RAND() * 30); -- VA A GENERAR UN DIA RANDOM HASTA 30 QUE VA A SER SUMADO O RESTADO
			SET @timeStamps = DATE_ADD(NOW(), INTERVAL @randomDays DAY);

			INSERT INTO payment_AIMessages (
				`FK_messageTypeId`,
				`role`,
				`content`,
				`enabled`,
				`idconversations`,
				`timeStamp`,
				`promptTokens`,
				`totalTokens`,
				`completionTokens`,
				`transcriptionId`,
				`AIresponseId`,
				`idgenerateaudios`
			)
			VALUES (
				@FK_messageTypeId,
				@role,
				@content,
				@enabled,
				@idconversations,
				@timeStamps,
				@promptTokens,
				@totalTokens,
				@completionTokens,
				@transcriptionId,
				@AIresponseId,
				@idgenerateaudios
			);
            
            SET @idConversation = CASE 
				WHEN @i%5 = 0 AND @idConversation != 59 THEN @idConversation + 1 
				ELSE @idConversation
			 END;
            
            SET @i = @i + 1;
            
		END WHILE;
END//

DELIMITER ;

call insertPaymentAIMessages();

-- LOG DE IA
INSERT INTO `paymentdb`.`payment_eventTypes` (`name`, `enable`)
VALUES
    ('Interpretation Error', 1),
    ('AI Hallucination', 1),
    ('Invalid Input Error', 1),
    ('Timeout Error', 1),
    ('Connection Failure', 1),
    ('Task Completed Successfully', 1),
    ('User Query Resolved', 1),
    ('AI Response Confirmed', 1),
    ('Data Processed', 1),
    ('Transaction Successful', 1);

DELIMITER //

CREATE PROCEDURE insertAIpaymentData()
BEGIN
    SET @i = 0;
    
    WHILE @i < 60 DO
        SET @userId = FLOOR(1 + RAND() * 31);  
        SET @scheduleId = null; 
        SET @currencyId = 7; 
        SET @availablePaymentMethodPerUser = null; 
        SET @availablePaymentMethodPerServiceId = null; 
        
        SET @amount = ROUND(10 + (RAND() * 1000), 2);  
        SET @description = CONCAT('Payment for service ', FLOOR(1 + RAND() * 10)); 
        SET @scheduledDate = DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 30) DAY);  
        
        INSERT INTO payment_AIpaymentData (
            `idpaymentData`, 
            `amount`, 
            `description`, 
            `scheduledDate`, 
            `userId`, 
            `scheduleId`, 
            `currencyId`, 
            `availablePaymentMethodPerUser`, 
            `availablePaymentMethodPerServiceId`
        )
        VALUES (
            @i + 1,  -- Use @i for incrementing idpaymentData
            @amount, 
            @description, 
            @scheduledDate, 
            @userId, 
            @scheduleId, 
            @currencyId, 
            @availablePaymentMethodPerUser, 
            @availablePaymentMethodPerServiceId
        );
        
        SET @i = @i + 1;
    END WHILE;
END//

DELIMITER ;

call insertAIpaymentData();

DELIMITER //

CREATE PROCEDURE insertPaymentAnalysisLogs()
BEGIN

	SET @i = 0;
    
    WHILE @i < 100 DO
        -- Generación de valores aleatorios
        SET @IdpaymentData = FLOOR(1 + RAND() * 60);  -- ID de datos de pago aleatorio
        SET @IdeventType = FLOOR(1 + RAND() * 5);  -- ID de tipo de evento aleatorio
        SET @Idconversations = FLOOR(1 + RAND() * 60);  -- ID de conversación aleatorio
        SET @MessageId = FLOOR(1 + RAND() * 596);  -- ID de mensaje aleatorio
		SET @timestamp = FROM_UNIXTIME(
				FLOOR(UNIX_TIMESTAMP(CONCAT(YEAR(NOW()), '-01-01 00:00:00')) + 
					  RAND() * (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(CONCAT(YEAR(NOW()), '-01-01 00:00:00'))))
				);
        -- Inserción en la tabla payment_paymentAnalysisLogs
        INSERT INTO payment_paymentAnalysisLogs (
            `AIanalysisId`,
            `timestamp`,
            `idpaymentData`,
            `ideventType`,
            `idconversations`,
            `messageId`
        ) 
        VALUES (
			null,
            @timestamp,
            @IdpaymentData,
            @IdeventType,
            @Idconversations, 
            @MessageId
        );

        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call insertPaymentAnalysisLogs();

