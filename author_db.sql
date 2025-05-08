#Ejercicio 1, Normalizar una base de datos de blogs
CREATE TABLE author (
                        author_id INT PRIMARY KEY AUTO_INCREMENT,
                        name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE blogs(
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      author_id INT NOT NULL ,
                      title VARCHAR(255) NOT NULL UNIQUE ,
                      word_count INT NOT NULL CHECK ( word_count >=0 ) ,
                      views INT NOT NULL CHECK ( views >= 0),
                      FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE INDEX idx_author_id ON blogs(author_id);

INSERT INTO author (name)
    VALUE ('Maria Charlotte'),
    ('Juan Perez'),
    ('Gemma Alcocer');


INSERT INTO blogs ( author_id,title, word_count, views)
    value (1,'Best Paint Colors', 814, 14),
    (2,'Small Space Decorating Tips', 1146, 221),
    (1,'Hot Accessories', 986, 105),
    (1,'Mixing Textures', 765, 22),
    (2,'Kitchen Refresh', 1242, 307),
    (1, 'Homemade Art Hacks', 1002, 193),
    (3, 'Refinishing Wood Floors', 1571, 7542);

SELECT author.name, blogs.title
FROM blogs
         INNER JOIN author ON blogs.author_id = author.author_id;



#Ejercicio 2.

#Tabla de clientes customers
CREATE TABLE customers (
                           customer_id INT PRIMARY KEY AUTO_INCREMENT,
                           customer_name VARCHAR(255) NOT NULL,
                           customer_status VARCHAR(50) NOT NULL,
                           customer_mileage INT NOT NULL CHECK ( customer_mileage >= 0 )
);

#Tabla para las aeronaves
CREATE TABLE aircraft(
                         airCraft_id INT PRIMARY KEY AUTO_INCREMENT,
                         model_code VARCHAR(50) NOT NULL ,
                         model_name VARCHAR(255) NOT NULL
);

#Tabla para los vuelos flights
CREATE TABLE flights(
                        flight_id INT PRIMARY KEY AUTO_INCREMENT,
                        flights_number VARCHAR(255) NOT NULL ,
                        aircraft_id INT NOT NULL ,
                        total_aircraft_seats INT NOT NULL CHECK (total_aircraft_seats > 0),
                        flights_mileage INT NOT NULL CHECK (flights_mileage >= 0),
                        FOREIGN KEY (aircraft_id) REFERENCES aircraft(airCraft_id)
);


#Tabla de viajes
CREATE TABLE booking(
                        booking_id INT PRIMARY KEY AUTO_INCREMENT,
                        customer_id INT NOT NULL ,
                        flight_id INT NOT NULL ,
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
                        FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

CREATE INDEX idx_customer_id ON customers(customer_name);
CREATE INDEX idx_aircraft_model_code ON aircraft(model_code);
CREATE INDEX idx_flights_number ON flights(flights_number);
CREATE INDEX idx_booking_customer On booking(customer_id);
CREATE INDEX idx_booking_flight ON booking(flight_id);


INSERT INTO customers (customer_name, customer_mileage, customer_status )
    VALUE ('Agustine Riviera', 115235, 'Silver'),
    ('Alaina Sepulvida', 6008, 'None'),
    ('Tom James', 205767, 'Gold'),
    ('San Rio', 2653, 'None'),
    ('Jessica james', 127656, 'Silver'),
    ('Ana Janco', 136773, 'Silver'),
    ('Jennifer Cortez', 300582, 'Gold'),
    ('Christian Janco', 14642, 'Silver');

INSERT INTO aircraft(model_code, model_name)
    VALUE ('747', 'Boeing'),
    ('A330', 'Airbus'),
    ('777', 'Boeing');

INSERT INTO flights(flights_number, aircraft_id, total_aircraft_seats, flights_mileage)
    VALUE ('DL143', 1, 400, 135),
    ('DL122', 2, 236, 4370),
    ('DL53', 3, 264, 2078),
    ('DL222', 3, 264, 1765),
    ('DL37', 1, 400, 531);

INSERT INTO booking(customer_id, flight_id)
    VALUE (1, 1),
    (1,2),
    (2,2),
    (1, 1),
    (3, 2),
    (3, 3),
    (1,1),
    (4, 1),
    (1, 1),
    (3, 4),
    (5, 1),
    (4, 1),
    (6, 4),
    (7, 4),
    (5, 2),
    (4, 5),
    (8, 4);

#Número total de vuelos:
SELECT COUNT(DISTINCT flights.flights_number) FROM flights;

#Distancia media de los vuelos:
SELECT AVG(flights_mileage) FROM flights;

#Número medio de plazas por avión:
SELECT AVG(flights.total_aircraft_seats) FROM flights;

#Millas medias recorridas por los clientes, agrupadas por estado:
SELECT customer_status, AVG(customers.customer_mileage) FROM customers GROUP BY customer_status;

#Máximo de millas recorridas por clientes, agrupadas por estado:
SELECT customer_status, MAX(customer_mileage) FROM customers GROUP BY  customer_status;

#Número de aviones con el nombre "Boeing":
SELECT COUNT(*) FROM aircraft WHERE  model_name LIKE '%Boeing%';

#Vuelos con distancia entre 300 y 2000 millas:
SELECT * FROM flights WHERE flights_mileage BETWEEN 300 AND 2000;

#Distancia media de vuelos reservados, agrupada por estado del cliente:
SELECT c.customer_status, AVG(f.flights_mileage) AS average_mileage
FROM booking b
         JOIN customers c ON b.customer_id = c.customer_id
         JOIN flights f ON b.flight_id = f.flight_id
GROUP BY c.customer_status;

#Avión más reservado por miembros con estado Gold:
SELECT a.model_name AS aircraft_name, COUNT(*) AS total_bookings
FROM booking b
         JOIN customers c ON b.customer_id = c.customer_id
         JOIN flights f ON b.flight_id = f.flight_id
         JOIN aircraft a ON f.aircraft_id = a.aircraft_id
WHERE c.customer_status = 'Gold'
GROUP BY a.model_name
ORDER BY total_bookings DESC
LIMIT 1;
