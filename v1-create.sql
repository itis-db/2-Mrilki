/**
 @author Mrilki Denis Kim 11-305
*/
CREATE TABLE IF NOT EXISTS Pick_up_point
(
    pointID        SERIAL PRIMARY KEY,
    name           VARCHAR(50),
    numberOfFloors INTEGER

);

CREATE TABLE IF NOT EXISTS Consultant
(
    consultantID SERIAL PRIMARY KEY,
    firstName    VARCHAR(30),
    lastName     VARCHAR(50),
    phone        VARCHAR(20) UNIQUE,
    termOfWork   INTEGER,
    jobTitle     VARCHAR(50)
);

CREATE TABLE  IF NOT EXISTS Consultant_pick_up_point
(
    consultantID INT REFERENCES Consultant (consultantID),
    pointID      INT REFERENCES Pick_up_point (pointID),
    PRIMARY KEY (consultantID, pointID)

);

CREATE TABLE IF NOT EXISTS Item
(
    itemID SERIAL PRIMARY KEY,
    name   VARCHAR(50) UNIQUE ,
    weight DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS Customers
(
    customersId SERIAL PRIMARY KEY,
    firstName   VARCHAR(30),
    lastName    VARCHAR(50),
    age         INTEGER,
    email       VARCHAR(50) UNIQUE
);

CREATE TABLE IF NOT EXISTS Orders
(
    orderId       SERIAL PRIMARY KEY,
    customers     INTEGER REFERENCES Customers (customersId),
    item          INTEGER REFERENCES Item (itemID),
    pick_up_point INTEGER REFERENCES Pick_up_point (PointID)
);
