use paymentdb;

-- ---------------------
-- CONSULTA 4.1
-- ---------------------

SELECT userTable.userId, 
		userTable.NombreCompleto,
        countryTable.Pais,
        contactTable.Email,
        coalesce(transactionTable.PagosSuscripciones, 0) AS PagosSuscripciones,
        coalesce(transactionTable.MonedaOriginal, 'Ninguna') AS MonedaOriginal,
        -- Esta linea convierte el Pago de la moneda original a Colones 
        (coalesce(transactionTable.PagosSuscripciones, 0) * (SELECT exchangeRate FROM payment_exchangeRates WHERE exchangeRateId = 5)) AS PagosSuscripcionesEnColones
FROM 
(
	SELECT userId, CONCAT(firstName, ' ', lastName) AS NombreCompleto, FK_countryId
	FROM payment_users
    WHERE enabled = 1                                     -- Se asegura que los usuarios listados esten activos
) AS userTable
INNER JOIN (
	SELECT countryId, name AS Pais
	FROM payment_countries
) AS countryTable ON userTable.FK_countryId = countryTable.countryId
INNER JOIN (
	SELECT contactUserInfoId, value AS Email, FK_contactInfoTypesId, FK_userId
	FROM payment_contactsUserInfo
	WHERE FK_contactInfoTypesId = 1                                       -- 1 es tipo Email
) AS contactTable ON userTable.userId = contactTable.FK_userId
LEFT JOIN (                                                               -- Se realiza un LEFT JOIN para ver todos los usuarios
	SELECT SUM(amount) AS PagosSuscripciones, FK_userId, MAX(name) AS MonedaOriginal,
    CASE 
	WHEN MAX(FK_currencyIdsource) > 1 THEN COALESCE(SUM(amount),0) * MAX(exchangeRate)    
    ELSE SUM(amount)
	END AS PagosSuscripcionesEnDolares                            -- Se convierte todo en dolares
    
	FROM payment_transactions
    INNER JOIN payment_exchangeRates ON payment_transactions.FK_exchangeRateId = payment_exchangeRates.exchangeRateId
		INNER JOIN payment_currencies ON payment_exchangeRates.FK_currencyIdsource = payment_currencies.currencyId
	WHERE YEAR(transDateTime) >= 2024 and FK_transSubTypeId = 1            -- Se asegura que los pagos sean de 2024 en adelante y
    GROUP BY FK_userId                                                     -- que sean pagos para suscripciones (transSubType = 1 es suscripcion)
) AS transactionTable ON userTable.userId = transactionTable.FK_userId;

-- ---------------------
-- CONSULTA 4.2
-- ---------------------

SELECT userTable.userId, 
		userTable.NombreCompleto,
        contactTable.Email,
        planPerUserTable.FechaDelUltimoPago,
        planPerUserTable.FechaDelSiguientePago,
        DATEDIFF(planPerUserTable.FechaDelSiguientePago, now()) AS DiasHastaElPago
FROM 
(
	SELECT userId, CONCAT(firstName, ' ', lastName) AS NombreCompleto, FK_countryId
	FROM payment_users
    WHERE enabled = 1                                     -- Se asegura que los usuarios listados esten activos
) AS userTable
INNER JOIN (
	SELECT contactUserInfoId, value AS Email, FK_contactInfoTypesId, FK_userId
	FROM payment_contactsUserInfo
	WHERE FK_contactInfoTypesId = 1                                       -- 1 es tipo Email
) AS contactTable ON userTable.userId = contactTable.FK_userId
INNER JOIN (
	SELECT planPerUserId, FK_scheduledPaymentId, FK_userId, lastExecute AS FechaDelUltimoPago, nextExecute AS FechaDelSiguientePago
	FROM payment_plansPerUser
    INNER JOIN payment_scheduledPayments ON payment_plansPerUser.FK_scheduledPaymentId = payment_scheduledPayments.scheduledPaymentId    
		INNER JOIN payment_scheduleDetails ON payment_scheduledPayments.scheduleId = payment_scheduleDetails.schedulesDetailsId    
	WHERE now() > DATE_SUB(nextExecute, INTERVAL 15 DAY)
) AS planPerUserTable ON userTable.userId = planPerUserTable.FK_userId;
