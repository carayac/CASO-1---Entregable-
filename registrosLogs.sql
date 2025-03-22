use paymentdb;

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

SELECT *  FROM payment_logTypes;

INSERT INTO payment_logSources 
VALUES 
(1,'Database'),
(2,'Mobile app'),
(3,'Api server'),
(4,'Notification system');

SELECT *  FROM payment_logSources;

INSERT INTO payment_logSeverity
VALUES 
(1,'Info'),
(2,'Warning'),
(3,'Error');

SELECT *  FROM payment_logSeverity;

DELIMITER //
CREATE PROCEDURE InsertLogsLogin()

BEGIN
	SET @j = 2;
    
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
SELECT *  FROM payment_Logs;

DELIMITER //
CREATE PROCEDURE InsertLogsPayment()
BEGIN
	SET @j = 2;
    
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
SELECT *  FROM payment_Logs;






