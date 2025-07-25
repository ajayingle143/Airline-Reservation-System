# Airline-Reservation-System
# ✈️ Airline Reservation System

A mini airline reservation system built using **MySQL**. This project simulates basic airline operations like flight bookings, seat management, and customer records. It includes SQL schema design, sample data, queries, triggers, views, and reports.

---

## 📌 Project Objectives

- Design a normalized schema for flights, customers, bookings, and seats.
- Implement constraints and relationships (primary keys, foreign keys).
- Insert sample flight and booking records.
- Write SQL queries for searching flights and checking available seats.
- Add triggers to handle seat booking and cancellation logic.
- Generate a booking summary report.
- Create views to monitor real-time flight seat availability.

---

## 🛠️ Tools Used

- **MySQL Workbench**
- **MySQL Server**
- **DB Browser (optional for SQLite compatibility)**

---

## 🧱 Schema Design

### 1. `Flights`
Stores flight information.

### 2. `Customers`
Stores customer details.

### 3. `Bookings`
Links customers to flights, tracks booking and cancellation.

### 4. `Seats`
Tracks seat allocation and availability.

---

## ⚙️ Features

- 🧾 Real-time **booking and cancellation** tracking using **triggers**.
- 📊 **View** to monitor available seats per flight.
- 🔎 Search flights and seat availability by route.
- 📃 Booking summary report showing customer, flight, and seat data.

---

## 📁 Files Included

| File | Description |
|------|-------------|
| `airline_reservation.sql` | Full SQL script including schema, sample data, triggers, views, and queries |
| `README.md` | Project documentation (you are here) |

---

## ▶️ How to Use

1. Open **MySQL Workbench**.
2. Run `airline_reservation.sql` file.
3. Explore the following:
   - Flights and customers
   - Bookings and triggers
   - Query: Available seats
   - View: `Available_Seats_View`
   - Report: Booking summary

---

## 🔍 Sample Queries

### Search Flights

```sql
SELECT * FROM Flights
WHERE source = 'Mumbai' AND destination = 'Delhi';
SELECT seat_number FROM Seats
WHERE flight_id = 1 AND is_booked = FALSE;
CREATE VIEW Available_Seats_View AS
SELECT f.flight_id, airline_name, source, destination,
       COUNT(seat_id) AS available_seats
FROM Flights f
JOIN Seats s ON f.flight_id = s.flight_id
WHERE s.is_booked = FALSE
GROUP BY f.flight_id;

SELECT b.booking_id, c.full_name, f.airline_name, f.source, f.destination,
       f.departure_time, b.status, s.seat_number
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Flights f ON b.flight_id = f.flight_id
LEFT JOIN Seats s ON b.booking_id = s.booking_id;
