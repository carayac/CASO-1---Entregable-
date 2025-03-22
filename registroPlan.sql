use paymentdb;

INSERT INTO `paymentdb`.`payment_schedules` (`scheduleId`,`name`,`recurrencyType`)
VALUES 
(1,'Primero del mes','mensual'),
(2,'Cada 1 de enero','anual'),
(3,'Cada 2 semanas','semanal');

select * FROM payment_schedules;

DELIMITER //

CREATE PROCEDURE InsertScheduleDetails()
BEGIN
SET @i =0;
    
    WHILE @i < 27 DO
    
		-- Declaracion de variables
        SET @scheduleId = MOD(@i,3)+1;                                                     -- se asegura que siempre hayan horarios de todos los tipos
        SET @baseDate = DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 300) DAY);         -- primera fecha en que se agrega el horario de pago
        
        SELECT recurrencyType INTO @recurrencyType FROM payment_schedules WHERE scheduleId = @scheduleId;
        SELECT 30, 'MONTH' INTO @days, @datepart WHERE @scheduleId = 1; 
        SELECT 365, 'YEAR' INTO @days, @datepart WHERE @scheduleId = 2; 
        SELECT 14, 'WEEK' INTO @days, @datepart WHERE @scheduleId = 3; 
        
        SET @lastExec = DATE_ADD('2025-03-08', INTERVAL FLOOR(RAND() * 20) DAY);         -- ultima fecha en que se pago segun el horario
        SET @nextExec = DATE_ADD(@lastExec, INTERVAL @days DAY);                         -- siguiente fecha en que se pagara segun el horario
        
        INSERT INTO `paymentdb`.`payment_scheduleDetails` (`schedulesDetailsId`,`baseDate`,`datePart`, `lastExecute`, `nextExecute`, `FK_scheduleId`)
		VALUES 
		(@i+1,@baseDate, @datePart, @lastExec, @nextExec, @scheduleId);
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

-- DELETE FROM payment_scheduleDetails WHERE schedulesDetailsId >0;
call InsertScheduleDetails();
select * FROM payment_scheduleDetails;

DELIMITER //

CREATE PROCEDURE InsertScheduledPaymentSub()
BEGIN
SET @i =0;
    
    WHILE @i <= 30 DO
    
		-- Declaracion de variables
        SET @scheduleDetailsId = (FLOOR(RAND() * 9) * 3) + 1;        -- se elige uno de los horarios mensuales al ser una suscripcion (1,4,7...)
        SET @FK_userId = 0;  
        SET @FK_serviceId = FLOOR(1 + RAND() * 4);                   -- se elige alguno de los 4 servicios
		SET @amount = RAND() * 200;
        SET @currencyId = FLOOR(1 + RAND() * 7);                     -- se elige alguna de las 7 monedas
        
        SELECT userId INTO @FK_userId FROM payment_users WHERE userId = @i;

		INSERT INTO payment_scheduledPayments (scheduleDetailsId, userId, serviceId, amount, currencyId)
        VALUES 
        (@scheduleDetailsId, @FK_userId, @FK_serviceId, @amount, @currencyId);  
        
        SET @i = @i + 1;
    END WHILE;
END //

DELIMITER ;

call InsertScheduledPaymentSub();
select * from payment_scheduledPayments;

DELIMITER //

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
select * from payment_scheduledPayments;
