-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema paymentdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema paymentdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `paymentdb` DEFAULT CHARACTER SET utf8 ;
USE `paymentdb` ;

-- -----------------------------------------------------
-- Table `paymentdb`.`payment_modules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_modules` (
  `moduleid` TINYINT(8) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`moduleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_restrictions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_restrictions` (
  `restrictionId` INT NOT NULL,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `moduleid` TINYINT(8) NOT NULL,
  PRIMARY KEY (`restrictionId`),
  INDEX `fk_pet_permissions_pets_modules1_idx` (`moduleid` ASC) VISIBLE,
  CONSTRAINT `fk_pet_permissions_pets_modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `paymentdb`.`payment_modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_roles` (
  `roleId` INT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`roleId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_rolesrestrictions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_rolesrestrictions` (
  `rolerestrictionsid` INT NOT NULL AUTO_INCREMENT,
  `FK_restrictionid` INT NOT NULL,
  `FK_roleId` INT NOT NULL,
  `lastupdate` DATETIME NOT NULL DEFAULT NOW(),
  `checksum` VARBINARY(500) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`rolerestrictionsid`),
  INDEX `fk_pets_rolespermissions_pets_permissions1_idx` (`FK_restrictionid` ASC) VISIBLE,
  INDEX `fk_payment_rolesrestrictions_payment_roles1_idx` (`FK_roleId` ASC) VISIBLE,
  CONSTRAINT `fk_pets_rolespermissions_pets_permissions1`
    FOREIGN KEY (`FK_restrictionid`)
    REFERENCES `paymentdb`.`payment_restrictions` (`restrictionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_rolesrestrictions_payment_roles1`
    FOREIGN KEY (`FK_roleId`)
    REFERENCES `paymentdb`.`payment_roles` (`roleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_Currencies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_Currencies` (
  `currencyId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `acronym` CHAR(3) NULL,
  `symbol` VARCHAR(5) NULL,
  PRIMARY KEY (`currencyId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_Countries` (
  `countryId` SMALLINT(1) NOT NULL AUTO_INCREMENT,
  `FK_currencyId` INT NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `phoneCode` VARCHAR(4) NOT NULL,
  `language` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`countryId`),
  INDEX `fk_payment_countries_payment_currency1_idx` (`FK_currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_countries_payment_currency1`
    FOREIGN KEY (`FK_currencyId`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AuthPlatforms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AuthPlatforms` (
  `authPlatformId` TINYINT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `secretKey` VARBINARY(128) NOT NULL,
  `key` VARBINARY(500) NOT NULL,
  `logoURL` VARCHAR(200) NULL,
  PRIMARY KEY (`authPlatformId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AuthSessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AuthSessions` (
  `authSessionId` INT NOT NULL AUTO_INCREMENT,
  `sessionId` VARCHAR(36) NOT NULL,
  `externalUser` VARCHAR(36) NOT NULL,
  `token` VARBINARY(500) NOT NULL,
  `refreshToken` VARBINARY(500) NOT NULL,
  `lastUpdate` DATETIME NOT NULL,
  `FK_authPlatformId` TINYINT NOT NULL,
  PRIMARY KEY (`authSessionId`),
  INDEX `fk_payment_authSessions_payment_authPlatforms1_idx` (`FK_authPlatformId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_authSessions_payment_authPlatforms1`
    FOREIGN KEY (`FK_authPlatformId`)
    REFERENCES `paymentdb`.`payment_AuthPlatforms` (`authPlatformId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_users` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(30) NOT NULL,
  `lastName` VARCHAR(30) NOT NULL,
  `password` VARBINARY(250) NULL,
  `birthdate` DATE NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `FK_countryId` SMALLINT(1) NOT NULL,
  `FK_authSessionId` INT NOT NULL,
  PRIMARY KEY (`userId`),
  INDEX `fk_payment_users_payment_Countries1_idx` (`FK_countryId` ASC) VISIBLE,
  INDEX `fk_payment_users_payment_AuthSessions1_idx` (`FK_authSessionId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_users_payment_Countries1`
    FOREIGN KEY (`FK_countryId`)
    REFERENCES `paymentdb`.`payment_Countries` (`countryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_users_payment_AuthSessions1`
    FOREIGN KEY (`FK_authSessionId`)
    REFERENCES `paymentdb`.`payment_AuthSessions` (`authSessionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_usersrestrictions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_usersrestrictions` (
  `userRestrictionId` INT NOT NULL AUTO_INCREMENT,
  `FK_restrictionid` INT NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `deleted` BIT(1) NOT NULL DEFAULT 0,
  `lastupdate` DATETIME NOT NULL DEFAULT NOW(),
  `checksum` VARBINARY(250) NOT NULL,
  `FK_userId` INT NOT NULL,
  PRIMARY KEY (`userRestrictionId`),
  INDEX `fk_pets_rolespermissions_pets_permissions1_idx` (`FK_restrictionid` ASC) VISIBLE,
  INDEX `fk_payment_usersrestrictions_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  CONSTRAINT `fk_pets_rolespermissions_pets_permissions10`
    FOREIGN KEY (`FK_restrictionid`)
    REFERENCES `paymentdb`.`payment_restrictions` (`restrictionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_usersrestrictions_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_businesses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_businesses` (
  `businessId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `logoURL` VARCHAR(200) NOT NULL,
  `password` VARBINARY(250) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`businessId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_serviceCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_serviceCategories` (
  `serviceCategoryId` TINYINT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`serviceCategoryId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_services` (
  `serviceId` INT NOT NULL AUTO_INCREMENT,
  `FK_userId` INT NOT NULL,
  `FK_serviceCategoryId` TINYINT NOT NULL,
  `logoURL` VARCHAR(200) NULL,
  PRIMARY KEY (`serviceId`),
  INDEX `fk_payment_businesses_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  INDEX `fk_payment_services_payment_serviceTypes1_idx` (`FK_serviceCategoryId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_businesses_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_services_payment_serviceTypes1`
    FOREIGN KEY (`FK_serviceCategoryId`)
    REFERENCES `paymentdb`.`payment_serviceCategories` (`serviceCategoryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_userRoles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_userRoles` (
  `userRoleId` TINYINT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT NOW(),
  `checkSum` VARBINARY(250) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  `deleted` BIT NOT NULL DEFAULT 0,
  `FK_roleId` INT NOT NULL,
  PRIMARY KEY (`userRoleId`),
  INDEX `fk_payment_userRoles_payment_users1_idx` (`userId` ASC) VISIBLE,
  INDEX `fk_payment_userRoles_payment_roles1_idx` (`FK_roleId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_userRoles_payment_users1`
    FOREIGN KEY (`userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_userRoles_payment_roles1`
    FOREIGN KEY (`FK_roleId`)
    REFERENCES `paymentdb`.`payment_roles` (`roleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_audioFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_audioFiles` (
  `audioFIleId` INT NOT NULL AUTO_INCREMENT,
  `audioURL` VARCHAR(200) NOT NULL,
  `filename` VARCHAR(255) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`audioFIleId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_paymentFrecuency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_paymentFrecuency` (
  `payment_paymentId` TINYINT NOT NULL,
  `days` INT NOT NULL DEFAULT 90,
  PRIMARY KEY (`payment_paymentId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_recurringpayments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_recurringpayments` (
  `serviceId` INT NOT NULL,
  `paymentsid` INT NOT NULL AUTO_INCREMENT,
  `paymenFrecuencyId` INT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `userId` INT NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT NOW(),
  `lastPayment` DATETIME NOT NULL DEFAULT NOW(),
  INDEX `fk_payment_recurringpayments_payment_services1_idx` (`serviceId` ASC) VISIBLE,
  PRIMARY KEY (`paymentsid`),
  INDEX `fk_payment_recurringpayments_payment_paymenttype1_idx` (`paymenFrecuencyId` ASC) VISIBLE,
  INDEX `fk_payment_recurringpayments_payment_users1_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_recurringpayments_payment_services1`
    FOREIGN KEY (`serviceId`)
    REFERENCES `paymentdb`.`payment_services` (`serviceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_recurringpayments_payment_paymenttype1`
    FOREIGN KEY (`paymenFrecuencyId`)
    REFERENCES `paymentdb`.`payment_paymentFrecuency` (`payment_paymentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_recurringpayments_payment_users1`
    FOREIGN KEY (`userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_contactInfoTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_contactInfoTypes` (
  `contactInfoTypeId` TINYINT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`contactInfoTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_contactsUserInfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_contactsUserInfo` (
  `contactUserInfoId` INT NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(255) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT NOW(),
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `FK_contactInfoTypesId` TINYINT NOT NULL,
  `countryId` SMALLINT(1) NULL,
  `FK_userId` INT NOT NULL,
  PRIMARY KEY (`contactUserInfoId`),
  INDEX `fk_payment_contactInfo_payment_contactInfoTypes1_idx` (`FK_contactInfoTypesId` ASC) VISIBLE,
  INDEX `fk_payment_contactInfo_payment_countries1_idx` (`countryId` ASC) VISIBLE,
  INDEX `fk_payment_contactUserInfo_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_contactInfo_payment_contactInfoTypes1`
    FOREIGN KEY (`FK_contactInfoTypesId`)
    REFERENCES `paymentdb`.`payment_contactInfoTypes` (`contactInfoTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contactInfo_payment_countries1`
    FOREIGN KEY (`countryId`)
    REFERENCES `paymentdb`.`payment_Countries` (`countryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contactUserInfo_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_contactServiceInfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_contactServiceInfo` (
  `contactServiceInfoId` INT NOT NULL,
  `value` VARCHAR(100) NOT NULL,
  `lastUpdate` DATETIME NOT NULL DEFAULT NOW(),
  `enabled` BIT NOT NULL DEFAULT 1,
  `FK_countryId` SMALLINT NOT NULL,
  `FK_serviceId` INT NOT NULL,
  `FK_contactInfoTypeId` TINYINT NOT NULL,
  PRIMARY KEY (`contactServiceInfoId`),
  INDEX `fk_payment_contactServiceInfo_payment_services1_idx` (`FK_serviceId` ASC) VISIBLE,
  INDEX `fk_payment_contactServiceInfo_payment_countries1_idx` (`FK_countryId` ASC) VISIBLE,
  INDEX `fk_payment_contactServiceInfo_payment_contactInfoTypes1_idx` (`FK_contactInfoTypeId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_contactServiceInfo_payment_services1`
    FOREIGN KEY (`FK_serviceId`)
    REFERENCES `paymentdb`.`payment_services` (`serviceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contactServiceInfo_payment_countries1`
    FOREIGN KEY (`FK_countryId`)
    REFERENCES `paymentdb`.`payment_Countries` (`countryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contactServiceInfo_payment_contactInfoTypes1`
    FOREIGN KEY (`FK_contactInfoTypeId`)
    REFERENCES `paymentdb`.`payment_contactInfoTypes` (`contactInfoTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_schedules` (
  `scheduleId` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `recurrencyType` VARCHAR(10) NOT NULL,
  `repit` VARCHAR(45) NULL,
  `endType` BIT NOT NULL DEFAULT 1,
  `endDate` DATETIME NULL DEFAULT MAXDATE(),
  `repitions` INT NULL,
  PRIMARY KEY (`scheduleId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_scheduleDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_scheduleDetails` (
  `schedulesDetailsId` INT NOT NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `baseDate` DATETIME NOT NULL,
  `datePart` VARCHAR(45) NOT NULL,
  `lastexecute` DATETIME NULL,
  `nextExecute` DATETIME NOT NULL,
  `FK_scheduleId` INT NOT NULL,
  PRIMARY KEY (`schedulesDetailsId`),
  INDEX `fk_payment_schedulesDetails_payment_schedules1_idx` (`FK_scheduleId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_schedulesDetails_payment_schedules1`
    FOREIGN KEY (`FK_scheduleId`)
    REFERENCES `paymentdb`.`payment_schedules` (`scheduleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_paymentmethods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_paymentmethods` (
  `paymentmethodsId` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `apiURL` VARCHAR(255) NOT NULL,
  `secretKey` VARBINARY(500) NOT NULL,
  `key` VARCHAR(64) NOT NULL,
  `logoIconURL` VARCHAR(255) NULL,
  `enabled` BIT NOT NULL DEFAULT true,
  PRIMARY KEY (`paymentmethodsId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AvailablePaymentMethods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AvailablePaymentMethods` (
  `avaliablepaymentmethodsId` INT NOT NULL,
  `name` VARCHAR(55) NOT NULL,
  `token` VARCHAR(255) NULL,
  `expTokenDate` DATETIME NULL,
  `maskAccount` VARCHAR(20) NULL,
  `callbackURLGET` VARCHAR(1000) NULL,
  `callbackPost` VARCHAR(1000) NULL,
  `callbackRedirect` VARCHAR(1000) NULL,
  `FK_paymentmethodsId` INT NOT NULL,
  `consumerKey` VARCHAR(255) NULL,
  `configurationJSON` JSON NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`avaliablepaymentmethodsId`),
  INDEX `fk_payment_avaliablepaymentmethods_payment_paymentmethods1_idx` (`FK_paymentmethodsId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_avaliablepaymentmethods_payment_paymentmethods10`
    FOREIGN KEY (`FK_paymentmethodsId`)
    REFERENCES `paymentdb`.`payment_paymentmethods` (`paymentmethodsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AvailablePaymentMethodsPerUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AvailablePaymentMethodsPerUser` (
  `availablePaymentMethodPerUser` INT NOT NULL AUTO_INCREMENT,
  `FK_avaliablepaymentmethodsId` INT NULL,
  `FK_userId` INT NOT NULL,
  `FK_contactUserInfoId` INT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`availablePaymentMethodPerUser`),
  INDEX `fk_payment_avaliablepaymentmethodperuser_payment_avaliablep_idx` (`FK_avaliablepaymentmethodsId` ASC) VISIBLE,
  INDEX `fk_payment_avaliablepaymentmethodperuser_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  INDEX `fk_payment_avaliablepaymentmethodperuser_payment_contactsUs_idx` (`FK_contactUserInfoId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_avaliablepaymentmethodperuser_payment_avaliablepay1`
    FOREIGN KEY (`FK_avaliablepaymentmethodsId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethods` (`avaliablepaymentmethodsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_avaliablepaymentmethodperuser_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_avaliablepaymentmethodperuser_payment_contactsUser1`
    FOREIGN KEY (`FK_contactUserInfoId`)
    REFERENCES `paymentdb`.`payment_contactsUserInfo` (`contactUserInfoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AvailablePaymentMethodsPerService`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AvailablePaymentMethodsPerService` (
  `availablePaymentMethodPerServiceId` INT NOT NULL AUTO_INCREMENT,
  `FK_avaliablepaymentmethodsId` INT NULL,
  `FK_serviceId` INT NOT NULL,
  `FK_contactServiceInfoId` INT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`availablePaymentMethodPerServiceId`),
  INDEX `fk_payment_avaliablepaymentmethodperservice_payment_avaliab_idx` (`FK_avaliablepaymentmethodsId` ASC) VISIBLE,
  INDEX `fk_payment_avaliablepaymentmethodperservice_payment_service_idx` (`FK_serviceId` ASC) VISIBLE,
  INDEX `fk_payment_avaliablepaymentmethodperservice_payment_contact_idx` (`FK_contactServiceInfoId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_avaliablepaymentmethodperservice_payment_avaliable1`
    FOREIGN KEY (`FK_avaliablepaymentmethodsId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethods` (`avaliablepaymentmethodsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_avaliablepaymentmethodperservice_payment_services1`
    FOREIGN KEY (`FK_serviceId`)
    REFERENCES `paymentdb`.`payment_services` (`serviceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_avaliablepaymentmethodperservice_payment_contactSe1`
    FOREIGN KEY (`FK_contactServiceInfoId`)
    REFERENCES `paymentdb`.`payment_contactServiceInfo` (`contactServiceInfoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_scheduledPayments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_scheduledPayments` (
  `scheduledPaymentId` INT NOT NULL,
  `scheduleId` INT NULL,
  `userId` INT NOT NULL,
  `serviceId` INT NOT NULL,
  `createdDate` DATETIME NOT NULL,
  `deleted` BIT NOT NULL,
  `lastUpdated` DATETIME NOT NULL,
  `enabled` BIT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `currencyId` INT NOT NULL,
  `avaliablepaymentmethodperuserId` INT NULL,
  `FK_availablePaymentMethodPerServiceId` INT NULL,
  PRIMARY KEY (`scheduledPaymentId`),
  INDEX `fk_payment_scheduledPayment_payment_schedules1_idx` (`scheduleId` ASC) VISIBLE,
  INDEX `fk_payment_scheduledPayment_payment_users1_idx` (`userId` ASC) VISIBLE,
  INDEX `fk_payment_scheduledPayment_payment_services1_idx` (`serviceId` ASC) VISIBLE,
  INDEX `fk_payment_scheduledPayment_payment_currency1_idx` (`currencyId` ASC) VISIBLE,
  INDEX `fk_payment_scheduledPayments_payment_avaliablepaymentmethod_idx1` (`avaliablepaymentmethodperuserId` ASC) VISIBLE,
  INDEX `fk_payment_scheduledPayments_payment_AvailablePaymentMethod_idx` (`FK_availablePaymentMethodPerServiceId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_scheduledPayment_payment_schedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `paymentdb`.`payment_schedules` (`scheduleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_scheduledPayment_payment_users1`
    FOREIGN KEY (`userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_scheduledPayment_payment_services1`
    FOREIGN KEY (`serviceId`)
    REFERENCES `paymentdb`.`payment_services` (`serviceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_scheduledPayment_payment_currency1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_scheduledPayments_payment_avaliablepaymentmethodpe2`
    FOREIGN KEY (`avaliablepaymentmethodperuserId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethodsPerUser` (`availablePaymentMethodPerUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_scheduledPayments_payment_AvailablePaymentMethodsP1`
    FOREIGN KEY (`FK_availablePaymentMethodPerServiceId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethodsPerService` (`availablePaymentMethodPerServiceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_statusTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_statusTypes` (
  `idstatusType` INT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idstatusType`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_paymentAttempts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_paymentAttempts` (
  `paymentAttemptId` BIGINT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `actualAmount` DECIMAL(10,2) NOT NULL,
  `FK_moduleid` TINYINT(8) NOT NULL,
  `FK_userId` INT NOT NULL,
  `FK_currencyId` INT NOT NULL,
  `result` VARCHAR(45) NULL,
  `chargeToken` VARBINARY(255) NULL,
  `description` VARCHAR(45) NULL,
  `errror` INT NULL,
  `date` DATETIME NULL,
  `checkSum` VARBINARY(500) NULL,
  `scheduledPaymentId` INT NULL,
  `userAuthorized` BIT NULL DEFAULT FALSE,
  `FK_avaliablepaymentmethodperserviceId` INT NULL,
  `FK_avaliablepaymentmethodperuserId` INT NULL,
  `status` VARCHAR(50) NULL,
  `authNumber` VARCHAR(50) NULL,
  `response` BIT NULL,
  `FK_idstatusType` INT NOT NULL,
  PRIMARY KEY (`paymentAttemptId`, `FK_idstatusType`),
  INDEX `fk_payment_paymentAttempt_payment_scheduledPayment1_idx` (`scheduledPaymentId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAttempt_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAttempts_payment_avaliablepaymentmethodpe_idx` (`FK_avaliablepaymentmethodperserviceId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAttempts_payment_avaliablepaymentmethodpe_idx1` (`FK_avaliablepaymentmethodperuserId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAttempts_payment_currencies1_idx` (`FK_currencyId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAttempts_payment_modules1_idx` (`FK_moduleid` ASC) VISIBLE,
  INDEX `fk_payment_paymentAttempts_payment_statusTypes1_idx` (`FK_idstatusType` ASC) VISIBLE,
  CONSTRAINT `fk_payment_paymentAttempt_payment_scheduledPayment1`
    FOREIGN KEY (`scheduledPaymentId`)
    REFERENCES `paymentdb`.`payment_scheduledPayments` (`scheduledPaymentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAttempt_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAttempts_payment_avaliablepaymentmethodpers1`
    FOREIGN KEY (`FK_avaliablepaymentmethodperserviceId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethodsPerService` (`availablePaymentMethodPerServiceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAttempts_payment_avaliablepaymentmethodperu1`
    FOREIGN KEY (`FK_avaliablepaymentmethodperuserId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethodsPerUser` (`availablePaymentMethodPerUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAttempts_payment_currencies1`
    FOREIGN KEY (`FK_currencyId`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAttempts_payment_modules1`
    FOREIGN KEY (`FK_moduleid`)
    REFERENCES `paymentdb`.`payment_modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAttempts_payment_statusTypes1`
    FOREIGN KEY (`FK_idstatusType`)
    REFERENCES `paymentdb`.`payment_statusTypes` (`idstatusType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_ExchangeRates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_ExchangeRates` (
  `exchangeRateid` INT NOT NULL,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME NULL,
  `exchangerate` DECIMAL(10,4) NOT NULL,
  `enable` BIT NOT NULL DEFAULT true,
  `currentexchangerate` BIT NOT NULL DEFAULT true,
  `FK_currencyIdsource` INT NOT NULL,
  `FK_currencyIdDestiny` INT NOT NULL,
  PRIMARY KEY (`exchangeRateid`),
  INDEX `fk_payment_ExchangeRate_payment_currency1_idx` (`FK_currencyIdsource` ASC) VISIBLE,
  INDEX `fk_payment_ExchangeRate_payment_currency2_idx` (`FK_currencyIdDestiny` ASC) VISIBLE,
  CONSTRAINT `fk_payment_ExchangeRate_payment_currency1`
    FOREIGN KEY (`FK_currencyIdsource`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_ExchangeRate_payment_currency2`
    FOREIGN KEY (`FK_currencyIdDestiny`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_transTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_transTypes` (
  `idTransTyoe` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idTransTyoe`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_trasnSubTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_trasnSubTypes` (
  `transSubTypeId` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`transSubTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_transactions` (
  `transactionId` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(10,2) NOT NULL,
  `transDateTime` DATETIME NOT NULL,
  `postTime` DATETIME NOT NULL,
  `paymentAttemptId` BIGINT NULL,
  `refNumber` VARCHAR(100) NULL,
  `description` VARCHAR(255) NULL,
  `FK_userId` INT NULL,
  `FK_personId` INT NULL,
  `FK_exchangeRateid` INT NOT NULL,
  `FK_transSubTypeId` INT NOT NULL,
  `FK_idTransTyoe` INT NOT NULL,
  `checkSum` VARBINARY(250) NOT NULL,
  PRIMARY KEY (`transactionId`),
  INDEX `fk_payment_transaction_payment_paymentAttempt1_idx` (`paymentAttemptId` ASC) VISIBLE,
  INDEX `fk_payment_transaction_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  INDEX `fk_payment_transaction_payment_ExchangeRate1_idx` (`FK_exchangeRateid` ASC) VISIBLE,
  INDEX `fk_payment_transaction_payment_users2_idx` (`FK_personId` ASC) VISIBLE,
  INDEX `fk_payment_transaction_payment_trasnSubType1_idx` (`FK_transSubTypeId` ASC) VISIBLE,
  INDEX `fk_payment_transaction_payment_transTyoe1_idx` (`FK_idTransTyoe` ASC) VISIBLE,
  CONSTRAINT `fk_payment_transaction_payment_paymentAttempt1`
    FOREIGN KEY (`paymentAttemptId`)
    REFERENCES `paymentdb`.`payment_paymentAttempts` (`paymentAttemptId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_transaction_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_transaction_payment_ExchangeRate1`
    FOREIGN KEY (`FK_exchangeRateid`)
    REFERENCES `paymentdb`.`payment_ExchangeRates` (`exchangeRateid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_transaction_payment_users2`
    FOREIGN KEY (`FK_personId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_transaction_payment_trasnSubType1`
    FOREIGN KEY (`FK_transSubTypeId`)
    REFERENCES `paymentdb`.`payment_trasnSubTypes` (`transSubTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_transaction_payment_transTyoe1`
    FOREIGN KEY (`FK_idTransTyoe`)
    REFERENCES `paymentdb`.`payment_transTypes` (`idTransTyoe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_reminderTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_reminderTypes` (
  `reminderTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(15) NOT NULL,
  `enable` VARCHAR(45) NOT NULL,
  `answer_type` VARCHAR(20) NULL,
  `bodySMS` VARCHAR(1000) NULL,
  PRIMARY KEY (`reminderTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_NotificationsConfirmationsRecieved`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_NotificationsConfirmationsRecieved` (
  `NotificationConfirmationRecivedId` INT NOT NULL AUTO_INCREMENT,
  `FK_userId` INT NOT NULL,
  `recivedDate` DATETIME NOT NULL DEFAULT NOW(),
  `authorized` BIT NOT NULL DEFAULT TRUE,
  `confirmationMethod` VARCHAR(50) NOT NULL,
  `description` VARCHAR(255) NULL,
  `message` VARCHAR(255) NULL,
  `responseJSON` JSON NULL,
  PRIMARY KEY (`NotificationConfirmationRecivedId`),
  INDEX `fk_payment_NotificationConfirmationRecived_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_NotificationConfirmationRecived_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_NotificationMethods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_NotificationMethods` (
  `NotificationMethodId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `lastUpdated` DATETIME NOT NULL,
  `createdDate` DATETIME NOT NULL,
  `enable` VARCHAR(45) NOT NULL,
  `callBackURLGET` VARCHAR(255) NULL,
  `callBackURLPost` VARCHAR(255) NULL,
  `callBackURLRedirect` VARCHAR(255) NULL,
  `messagingServiceSid` VARCHAR(40) NULL,
  `authToken` VARCHAR(500) NULL,
  PRIMARY KEY (`NotificationMethodId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_reminders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_reminders` (
  `idreminder` INT NOT NULL AUTO_INCREMENT,
  `FK_reminderTypeId` INT NOT NULL,
  `FK_paymentAttemptId` BIGINT NOT NULL,
  `FK_userId` INT NOT NULL,
  `message` VARCHAR(1000) NULL,
  `status` TINYINT NOT NULL,
  `createdDate` DATETIME NOT NULL,
  `authorizedDate` DATETIME NULL,
  `FK_scheduledPaymentId` INT NOT NULL,
  `FK_NotificationConfirmationReceivedId` INT NULL,
  `FK_NotificationMethodId` INT NOT NULL,
  `lastReminder` BIT NOT NULL DEFAULT 1,
  `FKendusernumber_contactUserInfoId` INT NULL,
  `FKoutboundnumber_contactInfoUserId` INT NULL,
  `error` VARCHAR(255) NULL,
  `ticketId` VARCHAR(45) NULL,
  `requestID` INT NULL,
  `expectedResult` VARCHAR(15) NULL,
  `successInfo` JSON NULL,
  PRIMARY KEY (`idreminder`),
  INDEX `fk_payment_reminder_payment_reminderType1_idx` (`FK_reminderTypeId` ASC) VISIBLE,
  INDEX `fk_payment_reminder_payment_paymentAttempt1_idx` (`FK_paymentAttemptId` ASC) VISIBLE,
  INDEX `fk_payment_reminder_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  INDEX `fk_payment_reminder_payment_scheduledPayment1_idx` (`FK_scheduledPaymentId` ASC) VISIBLE,
  INDEX `fk_payment_reminder_payment_NotificationConfirmationRecived_idx` (`FK_NotificationConfirmationReceivedId` ASC) VISIBLE,
  INDEX `fk_payment_reminders_payment_NotificationMethod1_idx` (`FK_NotificationMethodId` ASC) VISIBLE,
  INDEX `fk_payment_reminders_payment_contactUserInfo1_idx` (`FKendusernumber_contactUserInfoId` ASC) VISIBLE,
  INDEX `fk_payment_reminders_payment_contactUserInfo2_idx` (`FKoutboundnumber_contactInfoUserId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_reminder_payment_reminderType1`
    FOREIGN KEY (`FK_reminderTypeId`)
    REFERENCES `paymentdb`.`payment_reminderTypes` (`reminderTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminder_payment_paymentAttempt1`
    FOREIGN KEY (`FK_paymentAttemptId`)
    REFERENCES `paymentdb`.`payment_paymentAttempts` (`paymentAttemptId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminder_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminder_payment_scheduledPayment1`
    FOREIGN KEY (`FK_scheduledPaymentId`)
    REFERENCES `paymentdb`.`payment_scheduledPayments` (`scheduledPaymentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminder_payment_NotificationConfirmationRecived1`
    FOREIGN KEY (`FK_NotificationConfirmationReceivedId`)
    REFERENCES `paymentdb`.`payment_NotificationsConfirmationsRecieved` (`NotificationConfirmationRecivedId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminders_payment_NotificationMethod1`
    FOREIGN KEY (`FK_NotificationMethodId`)
    REFERENCES `paymentdb`.`payment_NotificationMethods` (`NotificationMethodId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminders_payment_contactUserInfo1`
    FOREIGN KEY (`FKendusernumber_contactUserInfoId`)
    REFERENCES `paymentdb`.`payment_contactsUserInfo` (`contactUserInfoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_reminders_payment_contactUserInfo2`
    FOREIGN KEY (`FKoutboundnumber_contactInfoUserId`)
    REFERENCES `paymentdb`.`payment_contactsUserInfo` (`contactUserInfoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_audioperuser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_audioperuser` (
  `audioperuserId` INT NOT NULL AUTO_INCREMENT,
  `FK_audioFIleId` INT NOT NULL,
  `FK_userId` INT NOT NULL,
  PRIMARY KEY (`audioperuserId`),
  INDEX `fk_payment_audioperuser_payment_audioFile1_idx` (`FK_audioFIleId` ASC) VISIBLE,
  INDEX `fk_payment_audioperuser_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_audioperuser_payment_audioFile1`
    FOREIGN KEY (`FK_audioFIleId`)
    REFERENCES `paymentdb`.`payment_audioFiles` (`audioFIleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_audioperuser_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_planFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_planFeatures` (
  `planFeatureId` SMALLINT NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  `dataType` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`planFeatureId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_subscriptions` (
  `subscriptionId` TINYINT NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `logoURL` VARCHAR(200) NULL,
  PRIMARY KEY (`subscriptionId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_featuresPerPlan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_featuresPerPlan` (
  `featurePerPlanId` SMALLINT NOT NULL,
  `value` VARCHAR(120) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  `FK_planFeatureId` SMALLINT NOT NULL,
  `FK_subscriptionId` TINYINT NOT NULL,
  PRIMARY KEY (`featurePerPlanId`),
  INDEX `fk_payment_featuresPerPlan_payment_planFeatures1_idx` (`FK_planFeatureId` ASC) VISIBLE,
  INDEX `fk_payment_featuresPerPlan_payment_subscriptions1_idx` (`FK_subscriptionId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_featuresPerPlan_payment_planFeatures1`
    FOREIGN KEY (`FK_planFeatureId`)
    REFERENCES `paymentdb`.`payment_planFeatures` (`planFeatureId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_featuresPerPlan_payment_subscriptions1`
    FOREIGN KEY (`FK_subscriptionId`)
    REFERENCES `paymentdb`.`payment_subscriptions` (`subscriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_planPrices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_planPrices` (
  `planPriceId` INT NOT NULL,
  `amount` DECIMAL(10,2) NULL,
  `recurrencyType` VARCHAR(10) NOT NULL,
  `postTime` DATETIME NOT NULL,
  `endDate` DATETIME NOT NULL DEFAULT MAXDATE(),
  `current` BIT NOT NULL DEFAULT 1,
  `FK_subscriptionId` TINYINT NOT NULL,
  `FK_currencyId` INT NULL,
  PRIMARY KEY (`planPriceId`),
  INDEX `fk_payment_planPrices_payment_subscriptions1_idx` (`FK_subscriptionId` ASC) VISIBLE,
  INDEX `fk_payment_planPrices_payment_Currencies1_idx` (`FK_currencyId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_planPrices_payment_subscriptions1`
    FOREIGN KEY (`FK_subscriptionId`)
    REFERENCES `paymentdb`.`payment_subscriptions` (`subscriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_planPrices_payment_Currencies1`
    FOREIGN KEY (`FK_currencyId`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_plansPerUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_plansPerUser` (
  `planPerUserId` INT NOT NULL AUTO_INCREMENT,
  `adquisitionDate` DATETIME NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  `FK_planPriceId` INT NOT NULL,
  `FK_scheduledPaymentId` INT NOT NULL,
  `FK_userId` INT NOT NULL,
  PRIMARY KEY (`planPerUserId`),
  INDEX `fk_payment_planPerUser_payment_planPrices1_idx` (`FK_planPriceId` ASC) VISIBLE,
  INDEX `fk_payment_plansPerUser_payment_scheduledPayments1_idx` (`FK_scheduledPaymentId` ASC) VISIBLE,
  INDEX `fk_payment_plansPerUser_payment_users1_idx` (`FK_userId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_planPerUser_payment_planPrices1`
    FOREIGN KEY (`FK_planPriceId`)
    REFERENCES `paymentdb`.`payment_planPrices` (`planPriceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_plansPerUser_payment_scheduledPayments1`
    FOREIGN KEY (`FK_scheduledPaymentId`)
    REFERENCES `paymentdb`.`payment_scheduledPayments` (`scheduledPaymentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_plansPerUser_payment_users1`
    FOREIGN KEY (`FK_userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_planLimits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_planLimits` (
  `planLimitId` TINYINT NOT NULL,
  `limit` VARCHAR(120) NULL DEFAULT 2,
  `FK_planFeatureId` SMALLINT NOT NULL,
  `FK_planPerUserId` INT NOT NULL,
  `unlimited` BIT NOT NULL,
  PRIMARY KEY (`planLimitId`),
  INDEX `fk_payment_planLimits_payment_planFeatures1_idx` (`FK_planFeatureId` ASC) VISIBLE,
  INDEX `fk_payment_planLimits_payment_plansPerUser1_idx` (`FK_planPerUserId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_planLimits_payment_planFeatures1`
    FOREIGN KEY (`FK_planFeatureId`)
    REFERENCES `paymentdb`.`payment_planFeatures` (`planFeatureId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_planLimits_payment_plansPerUser1`
    FOREIGN KEY (`FK_planPerUserId`)
    REFERENCES `paymentdb`.`payment_plansPerUser` (`planPerUserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_MasterCardStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_MasterCardStatus` (
  `MasterCardstatusId` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MasterCardstatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_APIMasterCardResponse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_APIMasterCardResponse` (
  `APIMasterCardResponse` INT NOT NULL AUTO_INCREMENT,
  `HTTPResponseCode` SMALLINT(1) NOT NULL,
  `MasterCardstatusId` INT NOT NULL,
  `requestDate` TIMESTAMP NOT NULL DEFAULT NOW(),
  `message` TEXT(1) NULL,
  PRIMARY KEY (`APIMasterCardResponse`),
  INDEX `fk_payment_APIMasterCardResponse_payment_MasterCardStatus1_idx` (`MasterCardstatusId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_APIMasterCardResponse_payment_MasterCardStatus1`
    FOREIGN KEY (`MasterCardstatusId`)
    REFERENCES `paymentdb`.`payment_MasterCardStatus` (`MasterCardstatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_LogTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_LogTypes` (
  `logTypeId` TINYINT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`logTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_LogSources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_LogSources` (
  `logSourceId` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`logSourceId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_LogSeverity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_LogSeverity` (
  `logSeverityId` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`logSeverityId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_Logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_Logs` (
  `logId` BIGINT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(80) NULL,
  `posttime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `computer` VARCHAR(150) NOT NULL,
  `username` VARCHAR(150) NOT NULL,
  `trace` VARCHAR(300) NULL,
  `referenceId1` BIGINT NULL,
  `referenceId2` BIGINT NULL,
  `value1` VARCHAR(300) NULL,
  `value2` VARCHAR(300) NULL,
  `checksum` VARBINARY(500) NOT NULL,
  `FK_logTypeId` TINYINT NOT NULL,
  `FK_logSourceId` INT NOT NULL,
  `FK_logSeverityId` INT NOT NULL,
  PRIMARY KEY (`logId`),
  INDEX `fk_payment_Logs_payment_LogTypes1_idx` (`FK_logTypeId` ASC) VISIBLE,
  INDEX `fk_payment_Logs_payment_LogSources1_idx` (`FK_logSourceId` ASC) VISIBLE,
  INDEX `fk_payment_Logs_payment_LogSeverity1_idx` (`FK_logSeverityId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_Logs_payment_LogTypes1`
    FOREIGN KEY (`FK_logTypeId`)
    REFERENCES `paymentdb`.`payment_LogTypes` (`logTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Logs_payment_LogSources1`
    FOREIGN KEY (`FK_logSourceId`)
    REFERENCES `paymentdb`.`payment_LogSources` (`logSourceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Logs_payment_LogSeverity1`
    FOREIGN KEY (`FK_logSeverityId`)
    REFERENCES `paymentdb`.`payment_LogSeverity` (`logSeverityId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_Languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_Languages` (
  `languageId` TINYINT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `culture` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`languageId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_Translations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_Translations` (
  `translationId` SMALLINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(50) NOT NULL,
  `caption` NVARCHAR(300) NOT NULL,
  `languageId` TINYINT NOT NULL,
  `FK_languageId` TINYINT NOT NULL,
  `FK_moduleid` TINYINT(8) NOT NULL,
  PRIMARY KEY (`translationId`),
  INDEX `fk_payment_Translations_payment_Languages1_idx` (`FK_languageId` ASC) VISIBLE,
  INDEX `fk_payment_Translations_payment_modules1_idx` (`FK_moduleid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_Translations_payment_Languages1`
    FOREIGN KEY (`FK_languageId`)
    REFERENCES `paymentdb`.`payment_Languages` (`languageId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Translations_payment_modules1`
    FOREIGN KEY (`FK_moduleid`)
    REFERENCES `paymentdb`.`payment_modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AISetup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AISetup` (
  `idAISetup` INT NOT NULL AUTO_INCREMENT,
  `callbackPost` VARCHAR(255) NULL,
  `temporaryKey` INT NULL DEFAULT 60,
  `webSocketClient` VARCHAR(255) NULL DEFAULT '60',
  `authToken` VARCHAR(255) NULL,
  `openapiKey` VARCHAR(255) NULL,
  PRIMARY KEY (`idAISetup`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_messageTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_messageTypes` (
  `messageTypeId` TINYINT NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`messageTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_conversationStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_conversationStatus` (
  `idconversationStatus` INT NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idconversationStatus`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_historyconversations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_historyconversations` (
  `idconversations` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `idAISetup` INT NOT NULL,
  `tokenQuantity` INT NOT NULL DEFAULT 0,
  `firstID` VARCHAR(255) NOT NULL,
  `lastID` VARCHAR(255) NULL,
  `finishReason` VARCHAR(105) NULL,
  `idconversationStatus` INT NOT NULL,
  `accuracyLevel` VARCHAR(45) NOT NULL DEFAULT '100.00',
  PRIMARY KEY (`idconversations`),
  INDEX `fk_payment_conversations_payment_users1_idx` (`userId` ASC) VISIBLE,
  INDEX `fk_payment_conversations_payment_AISetup1_idx` (`idAISetup` ASC) VISIBLE,
  INDEX `fk_payment_historyconversations_payment_conversationStatus1_idx` (`idconversationStatus` ASC) VISIBLE,
  CONSTRAINT `fk_payment_conversations_payment_users1`
    FOREIGN KEY (`userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_conversations_payment_AISetup1`
    FOREIGN KEY (`idAISetup`)
    REFERENCES `paymentdb`.`payment_AISetup` (`idAISetup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_historyconversations_payment_conversationStatus1`
    FOREIGN KEY (`idconversationStatus`)
    REFERENCES `paymentdb`.`payment_conversationStatus` (`idconversationStatus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AIMessages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AIMessages` (
  `messageId` INT NOT NULL AUTO_INCREMENT,
  `FK_messageTypeId` TINYINT NULL,
  `role` VARCHAR(15) NOT NULL,
  `content` VARCHAR(75) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  `idconversations` INT NOT NULL,
  `timeStamp` DATETIME NOT NULL,
  `promptTokens` INT NULL,
  `totalTokens` INT NULL,
  `completionTokens` INT NULL,
  PRIMARY KEY (`messageId`),
  INDEX `fk_payment_AIMessages_payment_messageType1_idx` (`FK_messageTypeId` ASC) VISIBLE,
  INDEX `fk_payment_AIMessages_payment_conversations1_idx` (`idconversations` ASC) VISIBLE,
  CONSTRAINT `fk_payment_AIMessages_payment_messageType1`
    FOREIGN KEY (`FK_messageTypeId`)
    REFERENCES `paymentdb`.`payment_messageTypes` (`messageTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIMessages_payment_conversations1`
    FOREIGN KEY (`idconversations`)
    REFERENCES `paymentdb`.`payment_historyconversations` (`idconversations`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AIModel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AIModel` (
  `idAIModel` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `enable` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idAIModel`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_Transcriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_Transcriptions` (
  `transcriptionId` INT NOT NULL AUTO_INCREMENT,
  `duration` DECIMAL(8,20) NOT NULL DEFAULT 0.00,
  `text` VARCHAR(4096) NULL,
  `FK_audioFIleId` INT NOT NULL,
  `FK_languageId` TINYINT NOT NULL,
  `idAIModel` INT NOT NULL,
  PRIMARY KEY (`transcriptionId`),
  INDEX `fk_payment_generatetranscriptions_payment_audioFiles1_idx` (`FK_audioFIleId` ASC) VISIBLE,
  INDEX `fk_payment_generatetranscriptions_payment_Languages1_idx` (`FK_languageId` ASC) VISIBLE,
  INDEX `fk_payment_generatetranscriptions_payment_AIModel1_idx` (`idAIModel` ASC) VISIBLE,
  CONSTRAINT `fk_payment_generatetranscriptions_payment_audioFiles1`
    FOREIGN KEY (`FK_audioFIleId`)
    REFERENCES `paymentdb`.`payment_audioFiles` (`audioFIleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_generatetranscriptions_payment_Languages1`
    FOREIGN KEY (`FK_languageId`)
    REFERENCES `paymentdb`.`payment_Languages` (`languageId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_generatetranscriptions_payment_AIModel1`
    FOREIGN KEY (`idAIModel`)
    REFERENCES `paymentdb`.`payment_AIModel` (`idAIModel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AIresponse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AIresponse` (
  `AIresponseId` INT NOT NULL AUTO_INCREMENT,
  `FK_messageId` INT NULL,
  `previous_responseid` INT NULL,
  `outputText` VARCHAR(4096) NOT NULL,
  `transcriptionId` INT NOT NULL,
  `idAIModel` INT NOT NULL,
  PRIMARY KEY (`AIresponseId`),
  INDEX `fk_payment_AIresponse_payment_agent1_idx` (`FK_messageId` ASC) VISIBLE,
  INDEX `fk_payment_AIresponse_payment_AIresponse1_idx` (`previous_responseid` ASC) VISIBLE,
  INDEX `fk_payment_AIresponse_payment_generatetranscriptions1_idx` (`transcriptionId` ASC) VISIBLE,
  INDEX `fk_payment_AIresponse_payment_AIModel1_idx` (`idAIModel` ASC) VISIBLE,
  CONSTRAINT `fk_payment_AIresponse_payment_agent1`
    FOREIGN KEY (`FK_messageId`)
    REFERENCES `paymentdb`.`payment_AIMessages` (`messageId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIresponse_payment_AIresponse1`
    FOREIGN KEY (`previous_responseid`)
    REFERENCES `paymentdb`.`payment_AIresponse` (`AIresponseId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIresponse_payment_generatetranscriptions1`
    FOREIGN KEY (`transcriptionId`)
    REFERENCES `paymentdb`.`payment_Transcriptions` (`transcriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIresponse_payment_AIModel1`
    FOREIGN KEY (`idAIModel`)
    REFERENCES `paymentdb`.`payment_AIModel` (`idAIModel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_audiosperAI`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_audiosperAI` (
  `idgenerateaudios` INT NOT NULL AUTO_INCREMENT,
  `voice` VARCHAR(10) NOT NULL,
  `reponseformat` VARCHAR(45) NOT NULL DEFAULT 'mp4',
  `payment_idAISetup` INT NOT NULL,
  `FK_idAIresponse_input` INT NOT NULL,
  `index` INT NULL,
  `expires_at` INT NULL,
  `idAIModel` INT NOT NULL,
  `audioFIleId` INT NOT NULL,
  PRIMARY KEY (`idgenerateaudios`),
  INDEX `fk_payment_generateaudios_payment_AISetup1_idx` (`payment_idAISetup` ASC) VISIBLE,
  INDEX `fk_payment_generateaudios_payment_AIresponse1_idx` (`FK_idAIresponse_input` ASC) VISIBLE,
  INDEX `fk_payment_generateaudios_payment_AIModel1_idx` (`idAIModel` ASC) VISIBLE,
  INDEX `fk_payment_generateaudios_payment_audioFiles1_idx` (`audioFIleId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_generateaudios_payment_AISetup1`
    FOREIGN KEY (`payment_idAISetup`)
    REFERENCES `paymentdb`.`payment_AISetup` (`idAISetup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_generateaudios_payment_AIresponse1`
    FOREIGN KEY (`FK_idAIresponse_input`)
    REFERENCES `paymentdb`.`payment_AIresponse` (`AIresponseId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_generateaudios_payment_AIModel1`
    FOREIGN KEY (`idAIModel`)
    REFERENCES `paymentdb`.`payment_AIModel` (`idAIModel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_generateaudios_payment_audioFiles1`
    FOREIGN KEY (`audioFIleId`)
    REFERENCES `paymentdb`.`payment_audioFiles` (`audioFIleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AIanalysis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AIanalysis` (
  `AIanalysisId` INT NOT NULL AUTO_INCREMENT,
  `AIresponseId` INT NOT NULL,
  `extractedEntities` JSON NULL,
  `creationDate` DATETIME NOT NULL DEFAULT NOW(),
  `idconversationStatus` INT NOT NULL,
  `messageId` INT NOT NULL,
  PRIMARY KEY (`AIanalysisId`),
  INDEX `fk_payment_AIanalysis_payment_AIresponse1_idx` (`AIresponseId` ASC) VISIBLE,
  INDEX `fk_payment_AIanalysis_payment_conversationStatus1_idx` (`idconversationStatus` ASC) VISIBLE,
  INDEX `fk_payment_AIanalysis_payment_AIMessages1_idx` (`messageId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_AIanalysis_payment_AIresponse1`
    FOREIGN KEY (`AIresponseId`)
    REFERENCES `paymentdb`.`payment_AIresponse` (`AIresponseId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIanalysis_payment_conversationStatus1`
    FOREIGN KEY (`idconversationStatus`)
    REFERENCES `paymentdb`.`payment_conversationStatus` (`idconversationStatus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIanalysis_payment_AIMessages1`
    FOREIGN KEY (`messageId`)
    REFERENCES `paymentdb`.`payment_AIMessages` (`messageId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_systemActionTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_systemActionTypes` (
  `idactionType` INT NOT NULL,
  `name` VARCHAR(75) NOT NULL,
  `enable` BIT NOT NULL DEFAULT 1,
  `eventDetails` VARCHAR(1000) NULL,
  PRIMARY KEY (`idactionType`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_AIpaymentData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_AIpaymentData` (
  `idpaymentData` INT NOT NULL,
  `amount` DECIMAL(10,2) NULL,
  `description` VARCHAR(255) NULL,
  `scheduledDate` DATETIME NULL,
  `userId` INT NULL,
  `scheduleId` INT NULL,
  `currencyId` INT NULL,
  `availablePaymentMethodPerUser` INT NULL,
  `availablePaymentMethodPerServiceId` INT NULL,
  PRIMARY KEY (`idpaymentData`),
  INDEX `fk_payment_AIpaymentData_payment_users1_idx` (`userId` ASC) VISIBLE,
  INDEX `fk_payment_AIpaymentData_payment_schedules1_idx` (`scheduleId` ASC) VISIBLE,
  INDEX `fk_payment_AIpaymentData_payment_Currencies1_idx` (`currencyId` ASC) VISIBLE,
  INDEX `fk_payment_AIpaymentData_payment_AvailablePaymentMethodsPer_idx` (`availablePaymentMethodPerUser` ASC) VISIBLE,
  INDEX `fk_payment_AIpaymentData_payment_AvailablePaymentMethodsPer_idx1` (`availablePaymentMethodPerServiceId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_AIpaymentData_payment_users1`
    FOREIGN KEY (`userId`)
    REFERENCES `paymentdb`.`payment_users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIpaymentData_payment_schedules1`
    FOREIGN KEY (`scheduleId`)
    REFERENCES `paymentdb`.`payment_schedules` (`scheduleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIpaymentData_payment_Currencies1`
    FOREIGN KEY (`currencyId`)
    REFERENCES `paymentdb`.`payment_Currencies` (`currencyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIpaymentData_payment_AvailablePaymentMethodsPerUs1`
    FOREIGN KEY (`availablePaymentMethodPerUser`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethodsPerUser` (`availablePaymentMethodPerUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_AIpaymentData_payment_AvailablePaymentMethodsPerSe1`
    FOREIGN KEY (`availablePaymentMethodPerServiceId`)
    REFERENCES `paymentdb`.`payment_AvailablePaymentMethodsPerService` (`availablePaymentMethodPerServiceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_paymentAnalysisLogs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_paymentAnalysisLogs` (
  `paymentAnalysisId` INT NOT NULL AUTO_INCREMENT,
  `AIanalysisId` INT NOT NULL,
  `scheduledPaymentId` INT NOT NULL,
  `idactionType` INT NOT NULL,
  `timestamp` TIMESTAMP NOT NULL DEFAULT now(),
  `idpaymentData` INT NOT NULL,
  PRIMARY KEY (`paymentAnalysisId`),
  INDEX `fk_payment_paymentAnalysis_payment_AIanalysis1_idx` (`AIanalysisId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAnalysis_payment_scheduledPayments1_idx` (`scheduledPaymentId` ASC) VISIBLE,
  INDEX `fk_payment_paymentAnalysis_payment_actionType1_idx` (`idactionType` ASC) VISIBLE,
  INDEX `fk_payment_paymentAnalysisLogs_payment_AIpaymentData1_idx` (`idpaymentData` ASC) VISIBLE,
  CONSTRAINT `fk_payment_paymentAnalysis_payment_AIanalysis1`
    FOREIGN KEY (`AIanalysisId`)
    REFERENCES `paymentdb`.`payment_AIanalysis` (`AIanalysisId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAnalysis_payment_scheduledPayments1`
    FOREIGN KEY (`scheduledPaymentId`)
    REFERENCES `paymentdb`.`payment_scheduledPayments` (`scheduledPaymentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAnalysis_payment_actionType1`
    FOREIGN KEY (`idactionType`)
    REFERENCES `paymentdb`.`payment_systemActionTypes` (`idactionType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_paymentAnalysisLogs_payment_AIpaymentData1`
    FOREIGN KEY (`idpaymentData`)
    REFERENCES `paymentdb`.`payment_AIpaymentData` (`idpaymentData`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `paymentdb`.`payment_TranscriptionSegments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paymentdb`.`payment_TranscriptionSegments` (
  `segmentId` INT NOT NULL AUTO_INCREMENT,
  `transcriptionId` INT NOT NULL,
  `seek` INT NOT NULL DEFAULT 0,
  `start` DECIMAL(8,20) NOT NULL DEFAULT 0.00,
  `end` DECIMAL(8,20) NOT NULL DEFAULT 0.00,
  `text` VARCHAR(4096) NULL,
  `avgLogProb` DECIMAL(8,10) NOT NULL DEFAULT 0.00,
  `compressionRatio` DECIMAL(8,10) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`segmentId`),
  INDEX `fk_payment_TranscriptionSegments_payment_Transcriptions1_idx` (`transcriptionId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_TranscriptionSegments_payment_Transcriptions1`
    FOREIGN KEY (`transcriptionId`)
    REFERENCES `paymentdb`.`payment_Transcriptions` (`transcriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
