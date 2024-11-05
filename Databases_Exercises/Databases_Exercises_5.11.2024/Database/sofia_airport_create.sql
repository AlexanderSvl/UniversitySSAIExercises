DROP DATABASE IF EXISTS sofia_airport;
CREATE DATABASE sofia_airport;

USE sofia_airport;

CREATE TABLE Passengers(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
	middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE Check_Ins(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	check_in_time DATETIME NOT NULL,
    passenger_id INT NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(id),
    flight_id INT NOT NULL, FOREIGN KEY (flight_id) REFERENCES Flights(id)
);

CREATE TABLE Airlines(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(50) NOT NULL,
    website VARCHAR(50),
    contact_phone VARCHAR(15) NOT NULL,
    IATA VARCHAR(2) NOT NULL,
    ICAO VARCHAR(3) NOT NULL,
    terminals_of_operation VARCHAR(5)
);

CREATE TABLE Flights(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    flight_number VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines(id),
    terminal VARCHAR(15) NOT NULL,
	check_in_desks VARCHAR(15) NOT NULL,
    gate VARCHAR(3) NOT NULL,
	departure_airport_code VARCHAR(5) NOT NULL,
	arrival_airport_code VARCHAR(5) NOT NULL,
    arrival_city VARCHAR(30) NOT NULL,
    expected_departure_time DATETIME NOT NULL,
	expected_arrival_time DATETIME NOT NULL
);

-- Insert passengers
INSERT INTO Passengers (first_name, middle_name, last_name, age)
VALUES 
('Georgi', 'Georgiev', 'Ivanov', 23),
('Ivanka', 'Dimitrova', 'Stoyanova', 44),
('Stefan', 'Borislavov', 'Todorov', 61);

-- Insert airlines
INSERT INTO Airlines (name, website, contact_phone, IATA, ICAO, terminals_of_operation)
VALUES 
('DEUTSCHE LUFTHANSA AG', 'https://www.lufthansa.com', '+49 69 6960', 'LH', 'DLH', 'T1, T2'),
('BULGARIA AIR', 'https://www.air.bg', '+359 2 402 0402', 'FB', 'BGL', 'T1, T2'),
('WIZZ AIR', 'https://www.wizzair.com', '+36 1 777 9292', 'W6', 'WZZ', 'T1, T2');

-- Insert flights
INSERT INTO Flights (flight_number, airline_id, terminal, check_in_desks, gate, departure_airport_code, arrival_airport_code, arrival_city, expected_departure_time, expected_arrival_time)
VALUES 
('LH1427', 1, 'T2', '18-24', 'B5', 'SOF', 'FRA', 'FRANKFURT', '2024-11-03 14:15:00', '2024-11-03 15:55:00'),
('FB471', 2, 'T2', '1-7', 'B4', 'SOF', 'MAD', 'MADRID', '2024-11-03 14:55:00', '2024-11-03 17:40:00'),
('W64377', 3, 'T1', '9-14', '3', 'SOF', 'CPH', 'COPENHAGEN', '2024-11-03 17:55:00', '2024-11-03 19:50:00');

-- Insert check-ins
INSERT INTO Check_Ins (check_in_time, passenger_id, flight_id)
VALUES 
('2024-11-03 12:03:00', 1, 1),  -- Georgi Georgiev Ivanov for LH1427
('2024-11-03 12:17:00', 2, 2),  -- Ivanka Dimitrova Stoyanova for FB471
('2024-11-03 15:11:00', 3, 3);  -- Stefan Borislavov Todorov for W64377