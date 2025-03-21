use paymentdb;

INSERT INTO `paymentdb`.`payment_Currencies` 
VALUES 
(1,'US Dollar', 'USD', '$'),
(2,'Euro', 'EUR', '€'),
(3,'British Pound Sterling', 'GBP', '£'),
(4,'Japanese Yen', 'JPY', '¥'),
(5,'Mexican Peso', 'MXN', '$'),
(6,'Russian Ruble', 'RUB', '₽'),
(7, 'Costa Rican Colon', 'CRC', '₡');

-- DELETE FROM payment_Currencies WHERE currencyId>0;

select currencyId, name, acronym, symbol from payment_Currencies;

INSERT INTO `paymentdb`.`payment_Countries` (`countryId`,`FK_currencyId`,`name`,`phoneCode`)
VALUES 
(1, 1, 'United States', '+1'),
(2, 2, 'France', '+33'),
(3, 2, 'Spain', '+34'),
(4, 4, 'Japan', '+81'),
(5, 5, 'Mexico', '+52'),
(6, 6, 'Russia', '+7'),
(7, 7, 'Costa Rica', '+506');

select countryId, FK_currencyId, name, phoneCode from payment_Countries;