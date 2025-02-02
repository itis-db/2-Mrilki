/**
  @author Mrilki Denis Kim 11-305

 */

-- change item
BEGIN;
ALTER TABLE orders
    ADD COLUMN item_name VARCHAR(50) REFERENCES item (name);

UPDATE orders
SET item_name = (SELECT name
                 FROM item
                 WHERE orders.item = item.itemid);

ALTER TABLE orders
    DROP COLUMN item;
ALTER TABLE item
    DROP COLUMN itemid;

ALTER TABLE item
    ADD PRIMARY KEY (name);

-- change customers
ALTER TABLE orders
    ADD COLUMN customers_email VARCHAR(50) REFERENCES customers (email);


UPDATE orders
SET customers_email = (SELECT email
                       FROM customers
                       WHERE orders.customers = customers.customersid);

ALTER TABLE orders
    DROP COLUMN customers;

ALTER TABLE customers
    DROP COLUMN customersid;

ALTER TABLE customers
    ADD PRIMARY KEY (email);


-- change consultant
ALTER TABLE consultant_pick_up_point
    ADD COLUMN consultant_phone VARCHAR(20) REFERENCES consultant (phone);

UPDATE consultant_pick_up_point
SET consultant_phone = (SELECT phone
                        FROM consultant
                        WHERE consultant_pick_up_point.consultantid = consultant.consultantid);

ALTER TABLE consultant_pick_up_point
    DROP COLUMN consultantid;

ALTER TABLE consultant
    DROP COLUMN consultantid;

ALTER TABLE consultant
    ADD PRIMARY KEY (phone);

-- change pick_up_point
ALTER TABLE pick_up_point
    ADD CONSTRAINT name_uniq UNIQUE (name);

ALTER TABLE consultant_pick_up_point
    ADD COLUMN point_name VARCHAR(50) REFERENCES pick_up_point (name);
ALTER TABLE orders
    ADD COLUMN point_name VARCHAR(50) REFERENCES pick_up_point (name);

UPDATE consultant_pick_up_point
SET point_name = (SELECT name FROM pick_up_point WHERE consultant_pick_up_point.pointid = pick_up_point.pointid);

UPDATE orders
SET point_name = (SELECT name FROM pick_up_point WHERE orders.pick_up_point = pick_up_point.pointid);

ALTER TABLE consultant_pick_up_point
    DROP COLUMN pointid;
ALTER TABLE orders
    DROP COLUMN pick_up_point;
ALTER TABLE pick_up_point
    DROP COLUMN pointid;
ALTER TABLE pick_up_point
    ADD PRIMARY KEY (name);
-- change consultant_pick_up_point
ALTER TABLE consultant_pick_up_point
    ADD PRIMARY KEY (consultant_phone, point_name);
-- change order
ALTER TABLE orders
    ADD CONSTRAINT order_uniq UNIQUE (item_name, customers_email, point_name);
ALTER TABLE orders
    DROP COLUMN orderid;
ALTER TABLE orders
    ADD PRIMARY KEY (item_name, customers_email, point_name);
COMMIT;

BEGIN;
-- rollback consultant_pick_up_point
ALTER TABLE consultant_pick_up_point
    DROP CONSTRAINT consultant_pick_up_point_pkey;
--rollback order
ALTER TABLE orders
    DROP CONSTRAINT orders_pkey;
ALTER TABLE orders
    DROP CONSTRAINT order_uniq;
ALTER TABLE orders
    ADD COLUMN orderid SERIAL UNIQUE;
ALTER TABLE orders
    ADD PRIMARY KEY (orderid);
--rollback item
ALTER TABLE item
    ADD COLUMN itemid SERIAL UNIQUE;

ALTER TABLE orders
    ADD COLUMN item INTEGER REFERENCES item (itemid);

UPDATE orders
SET item = (SELECT itemid FROM item WHERE orders.item_name = item.name);

ALTER TABLE orders
    DROP COLUMN item_name;
ALTER TABLE item
    DROP CONSTRAINT item_pkey;
ALTER TABLE item
    ADD PRIMARY KEY (itemid);

--rollback customers
ALTER TABLE customers
    ADD COLUMN customersid SERIAL UNIQUE;

ALTER TABLE orders
    ADD COLUMN customers INTEGER REFERENCES customers (customersid);

UPDATE orders
SET customers = (SELECT customersid FROM customers WHERE customers.email = orders.customers_email);

ALTER TABLE orders
    DROP COLUMN customers_email;
ALTER TABLE customers
    DROP CONSTRAINT customers_pkey;
ALTER TABLE customers
    ADD PRIMARY KEY (customersid);

-- rollback consultant
ALTER TABLE consultant
    ADD COLUMN consultantid SERIAL UNIQUE;

ALTER TABLE consultant_pick_up_point
    ADD COLUMN consultantid INTEGER REFERENCES consultant (consultantid);

UPDATE consultant_pick_up_point
SET consultantid = (SELECT consultantid
                    FROM consultant
                    WHERE consultant.phone = consultant_pick_up_point.consultant_phone);

ALTER TABLE consultant_pick_up_point
    DROP COLUMN consultant_phone;
ALTER TABLE consultant
    DROP CONSTRAINT consultant_pkey;
ALTER TABLE consultant
    ADD PRIMARY KEY (consultantid);


-- rollback pick_up_point
ALTER TABLE pick_up_point
    ADD COLUMN pointid SERIAL UNIQUE;
ALTER TABLE consultant_pick_up_point
    ADD COLUMN pointid INTEGER REFERENCES pick_up_point (pointid);
ALTER TABLE orders
    ADD COLUMN pick_up_point INTEGER REFERENCES pick_up_point (pointid);


UPDATE consultant_pick_up_point
SET pointid = (SELECT pointid FROM pick_up_point WHERE pick_up_point.name = consultant_pick_up_point.point_name);

UPDATE orders
SET pick_up_point = (SELECT pointid FROM pick_up_point WHERE pick_up_point.name = orders.point_name);

ALTER TABLE consultant_pick_up_point
    DROP COLUMN point_name;
ALTER TABLE orders
    DROP COLUMN point_name;
ALTER TABLE pick_up_point
    DROP CONSTRAINT pick_up_point_pkey;
ALTER TABLE pick_up_point
    ADD PRIMARY KEY (pointid);
ALTER TABLE pick_up_point
    DROP CONSTRAINT name_uniq;

-- rollback consultant_pick_up_point 2 part
ALTER TABLE consultant_pick_up_point
    ADD PRIMARY KEY (consultantid, pointid);
COMMIT;
