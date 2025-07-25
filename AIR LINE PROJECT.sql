DROP DATABASE IF EXISTS airline_reservation;
CREATE DATABASE airline_reservation;
USE airline_reservation;
CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_name VARCHAR(100),
    source VARCHAR(100),
    destination VARCHAR(100),
    departure_time DATETIME,
    arrival_time DATETIME,
    total_seats INT
);
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    flight_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Booked', 'Cancelled') DEFAULT 'Booked',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT,
    seat_number VARCHAR(5),
    is_booked BOOLEAN DEFAULT FALSE,
    booking_id INT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
-- Insert flights
INSERT INTO Flights (airline_name, source, destination, departure_time, arrival_time, total_seats)
VALUES 
('Air India', 'Mumbai', 'Delhi', '2025-08-01 08:00:00', '2025-08-01 10:00:00', 3),
('IndiGo', 'Delhi', 'Bangalore', '2025-08-02 09:30:00', '2025-08-02 12:30:00', 3);

-- Insert customers
INSERT INTO Customers (full_name, email, phone)
VALUES 
('Ajay Ingle', 'ajay@example.com', '9999999999'),
('Priya Sharma', 'priya@example.com', '8888888888');

-- Generate seats for each flight
INSERT INTO Seats (flight_id, seat_number)
VALUES 
(1, '1A'), (1, '1B'), (1, '1C'),
(2, '1A'), (2, '1B'), (2, '1C');

-- Create a booking
INSERT INTO Bookings (customer_id, flight_id)
VALUES (1, 1);

-- Update booked seat
UPDATE Seats SET is_booked = TRUE, booking_id = 1 WHERE flight_id = 1 AND seat_number = '1A';
SELECT * FROM Flights
WHERE source = 'Mumbai' AND destination = 'Delhi';
SELECT seat_number FROM Seats
WHERE flight_id = 1 AND is_booked = FALSE;
DELIMITER //
CREATE TRIGGER trg_after_booking
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Seats
    SET is_booked = TRUE, booking_id = NEW.booking_id
    WHERE flight_id = NEW.flight_id AND is_booked = FALSE
    LIMIT 1;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER trg_after_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' THEN
        UPDATE Seats
        SET is_booked = FALSE, booking_id = NULL
        WHERE booking_id = NEW.booking_id;
    END IF;
END;
//
DELIMITER ;
CREATE VIEW Available_Seats_View AS
SELECT 
    f.flight_id,
    f.airline_name,
    f.source,
    f.destination,
    COUNT(s.seat_id) AS available_seats
FROM Flights f
JOIN Seats s ON f.flight_id = s.flight_id
WHERE s.is_booked = FALSE
GROUP BY f.flight_id;
SELECT 
    b.booking_id,
    c.full_name,
    f.airline_name,
    f.source,
    f.destination,
    f.departure_time,
    b.status,
    s.seat_number
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Flights f ON b.flight_id = f.flight_id
LEFT JOIN Seats s ON b.booking_id = s.booking_id;
