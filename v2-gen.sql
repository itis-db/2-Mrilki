/**
  @author Mrilki Denis Kim 11-305
 */

-- add testdata for customer
INSERT INTO customers(firstName, lastName, age, email)
SELECT (ARRAY ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Frank', 'Grace', 'Hannah', 'Ian', 'Julia',
    'Kevin', 'Linda', 'Michael', 'Nancy', 'Oliver', 'Pamela', 'Quentin', 'Rachel', 'Samuel', 'Tina',
    'Ulysses', 'Victoria', 'Walter', 'Xavier', 'Yvonne', 'Zachary', 'Sophia', 'Liam', 'Emma', 'Noah',
    'Ava', 'Isabella', 'Mia', 'Olivia', 'Ethan', 'William', 'James', 'Benjamin', 'Henry', 'Alexander',
    'Amelia', 'Charlotte', 'Evelyn', 'Harper', 'Ella', 'Emily', 'Abigail', 'Elizabeth', 'Sofia', 'Avery'
    ])[floor(random() * 50 + 1)::int],
       (ARRAY ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
           'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
           'Lee', 'Walker', 'Hall', 'Young', 'King', 'Wright', 'Hill', 'Scott', 'Green', 'Adams',
           'Baker', 'Nelson', 'Carter', 'Mitchell', 'Perez', 'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker',
           'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan'
           ])[floor(random() * 50 + 1)::int],
       floor(random() * (50 - 18 + 1) + 18)::int,
       floor(random() * 500000)::text || '.' || '@mail.com'
FROM generate_series(1, 300);



-- add testdata for consultant
INSERT INTO consultant(firstName, lastName, phone, termOfWork, jobTitle)
SELECT (ARRAY ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Frank', 'Grace', 'Hannah', 'Ian', 'Julia',
    'Kevin', 'Linda', 'Michael', 'Nancy', 'Oliver', 'Pamela', 'Quentin', 'Rachel', 'Samuel', 'Tina',
    'Ulysses', 'Victoria', 'Walter', 'Xavier', 'Yvonne', 'Zacharyскаладовик', 'Sophia', 'Liam', 'Emma', 'Noah',
    'Ava', 'Isabella', 'Mia', 'Olivia', 'Ethan', 'William', 'James', 'Benjamin', 'Henry', 'Alexander',
    'Amelia', 'Charlotte', 'Evelyn', 'Harper', 'Ella', 'Emily', 'Abigail', 'Elizabeth', 'Sofia', 'Avery'
    ])[floor(random() * 50 + 1)::int],
       (ARRAY ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
           'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
           'Lee', 'Walker', 'Hall', 'Young', 'King', 'Wright', 'Hill', 'Scott', 'Green', 'Adams',
           'Baker', 'Nelson', 'Carter', 'Mitchell', 'Perez', 'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker',
           'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan'
           ])[floor(random() * 50 + 1)::int],
       '+' || floor(random() * 10000000000 + 1000000000)::VARCHAR(20),
       floor(random() * 500):: int,
       (ARRAY ['consultant', 'senior consultant', 'cashier', 'warehouse worker'])[floor(random() * 4 + 1)::int]
FROM generate_series(1, 300);

-- add testdata for item
INSERT INTO Item (name, weight)
VALUES
    ('Зарядное устройство', 0.20),
    ('Наушники', 0.10),
    ('Книга', 0.70),
    ('Ноутбук', 2.00),
    ('Планшет', 0.60),
    ('Ручка', 0.05),
    ('Блокнот', 0.25),
    ('Ключи', 0.15),
    ('Кошелек', 0.10),
    ('Бутылка воды', 0.55),
    ('Зонт', 0.40),
    ('Солнцезащитные очки', 0.08),
    ('Шапка', 0.12),
    ('Шарф', 0.18),
    ('Перчатки', 0.09),
    ('Футболка', 0.20),
    ('Джинсы', 0.65),
    ('Куртка', 1.20),
    ('Кроссовки', 0.80),
    ('Рюкзак', 0.75),
    ('Салфетки', 0.02),
    ('Жевательная резинка', 0.01),
    ('Пауэрбанк', 0.3);

-- add testdata for Consultant_pick_up_point
INSERT INTO Consultant_pick_up_point (consultantID, pointID)
SELECT DISTINCT ON (c.consultantID)
    c.consultantID,
    p.pointID
FROM
    Consultant c
        CROSS JOIN
    Pick_up_point p
ORDER BY
    c.consultantID,
    random()
ON CONFLICT (consultantID, pointID) DO NOTHING;

--unique
INSERT INTO Pick_up_point (name, numberOfFloors)
SELECT
    'Point_' || gs AS name,
    FLOOR(RANDOM() * 20) + 1 AS numberOfFloors
FROM generate_series(1, 10) AS gs;
-- add testdata for orders

ALTER TABLE Orders ADD CONSTRAINT unique_order UNIQUE (customers, item, pick_up_point);

INSERT INTO Orders (customers, item, pick_up_point)
WITH RandomValues AS (
    SELECT
        n,
        (SELECT customersId FROM Customers ORDER BY random() + n LIMIT 1) as customer_id,
        (SELECT itemID FROM Item ORDER BY random() + n LIMIT 1) as item_id,
        (SELECT pointID FROM Pick_up_point ORDER BY random() + n LIMIT 1) as point_id
    FROM generate_series(1, 300) as n
)
SELECT customer_id, item_id, point_id
FROM RandomValues;
