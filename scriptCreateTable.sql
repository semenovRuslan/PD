CREATE DATABASE BookStore;


######################  USERS
drop table `DimUsers`;
CREATE TABLE `DimUsers` (
  `UserID` int(11) NOT NULL default '0',
  `CityID` int(11) default NULL,
  `Location` varchar(250) default NULL,
  `Age` int(11) default NULL,
  PRIMARY KEY  (`UserID`)
);

drop table `DimCountry`;
CREATE TABLE `DimCountry` (
  `CountryID` int(11) NOT NULL,
  `CountryName` varchar(250) default NULL,
  PRIMARY KEY  (`CountryID`)
);

drop table `DimState`;
CREATE TABLE `DimState` (
  `StateID` int(11) NOT NULL,
  `CountryID` int(11) NOT NULL ,
  `StateName` varchar(250) default NULL,
  PRIMARY KEY  (`StateID`)
);

drop table `DimCity`;
CREATE TABLE `DimCity` (
  `CityID` int(11) NOT NULL,
  `StateID` int(11) NOT NULL ,
  `CityName` varchar(250) default NULL,
  PRIMARY KEY  (`CityID`)
);





############################    BOOKS
drop table `DimBooks`;
CREATE TABLE `DimBooks` (
   ISBN varchar(250) NOT NULL default '',
  `AuthorID` int(11) default NULL,
  PublisherID int(11) default NULL,
  `Title` varchar(255) default NULL,
  `Year` int(11) default NULL,
  PRIMARY KEY  (`ISBN`)
);

DROP TABLE DimAuthor;
CREATE TABLE DimAuthor (
AuthorID  int(11)  NOT NULL,
AuthorName VARCHAR(255)  default NULL,
 PRIMARY KEY  (`AuthorID`)
);


DROP TABLE DimPublisher;
CREATE TABLE DimPublisher (
PublisherID  int(11)  NOT NULL,
PublisherName VARCHAR(255)  default NULL,
 PRIMARY KEY  (`PublisherID`)
);

# add default value for properties
insert into dimcountry(CountryID, CountryName) values (-9999, 'na');
insert into DimState(StateID,CountryID,StateName) values (-9999, -9999,  'na');
insert into dimcity(CityID, StateID, cityName) values (-9999, -9999,  'na');
insert into dimpublisher(PublisherID, PublisherName) values (-9999, 'na');
insert into dimauthor(AuthorID, AuthorName) values (-9999, 'na');


#add condition for table

ALTER TABLE `bookstore`.`dimcountry` CHANGE COLUMN `CountryID` `CountryID` INT(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `bookstore`.`DimState` CHANGE COLUMN `StateID` `StateID` INT(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `bookstore`.`dimcity` CHANGE COLUMN `CityID` `CityID` INT(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `bookstore`.`dimpublisher` CHANGE COLUMN `PublisherID` `PublisherID` INT(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `bookstore`.`dimauthor` CHANGE COLUMN `AuthorID` `AuthorID` INT(11) NOT NULL AUTO_INCREMENT;
