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

select * from payment_Countries;

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


