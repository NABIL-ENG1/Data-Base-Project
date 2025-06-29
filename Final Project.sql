CREATE DATABASE Final_Project;

USE Final_Project;

CREATE TABLE Trainee(
trainee_id INT PRIMARY KEY,
Tname VARCHAR (50),
Gender CHAR(1),
email VARCHAR(60),
background VARCHAR(100)
);

CREATE TABLE Trainer (
trainer_id INT PRIMARY KEY,
name_t VARCHAR (100),
specialty VARCHAR (70),
phone CHAR(9),
email VARCHAR(70)
);

CREATE TABLE Course(
course_id INT PRIMARY KEY,
title VARCHAR (100),
category VARCHAR(5),
duration TIME,
c_Level VARCHAR(50)
);

CREATE TABLE schedule (
schedule_id INT PRIMARY KEY,
course_id INT,
trainer_id INT, 
start_date DATE,
end_date DATE,
time_slot VARCHAR(100),
FOREIGN KEY (course_id) REFERENCES Course(course_id),
FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

CREATE TABLE enrollment(
enrollment_id INT PRIMARY KEY,
trainee_id INT,
course_id INT,
enrollment_date DATE,
FOREIGN KEY (course_id) REFERENCES Course(course_id),
FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id)
);

SELECT * FROM Trainee;
SELECT * FROM Trainer;
SELECT * FROM Course;
SELECT * FROM schedule;
SELECT * FROM enrollment;

--- Trainee Table ---
INSERT INTO Trainee (trainee_id, Tname, Gender, email, background) VALUES
(1, 'Aisha Al-Harthy', 'F', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'M', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'F', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'M', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'F', 'fatma@example.com', 'Data Science');

--- Trainer Table ---
      --- ALTER TABLE Trainer ALTER COLUMN phone VARCHAR(15); ---
	  --- For phone column i have selected CHAR(9), BUT Omani phone number are 11 digits starting with country code 968--- 

ALTER TABLE Trainer ALTER COLUMN phone VARCHAR(15);

INSERT INTO Trainer (trainer_id, name_t, specialty, phone, email) VALUES
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');


--- Course Table --- 
     ---ALTER TABLE Course ALTER COLUMN duration INT; ---
	 ---  in course i have selected time for duration but it should be INT ---



ALTER TABLE Course ADD duration_hours INT;

ALTER TABLE Course DROP COLUMN duration;

INSERT INTO Course (course_id, title, category, duration_hours, c_Level) VALUES
(1, 'Database Fundamentals', 'DB', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'DS', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'DB', 15, 'Advanced');

 --- Schedule Table ---

INSERT INTO schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot) VALUES
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning'); 


--- Enrollment Table ---

INSERT INTO enrollment (enrollment_id, trainee_id, course_id, enrollment_date) VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');


                            --- SQL Query Instruction---    --- Trainee Perspective ------ Show all available courses (title, level, category)---SELECT title, c_Level AS level, category
FROM Course;

--- View beginner-level Data Science courses ---
SELECT title, c_Level AS level, category
FROM Course
WHERE c_Level = 'Beginner' AND category = 'Data Science';

--- Show courses this trainee is enrolled in ---
SELECT c.title
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
WHERE e.trainee_id = trainee_id;

--- View the schedule for the trainee's enrolled courses ---
SELECT s.start_date, s.time_slot
FROM Enrollment e
JOIN Schedule s ON e.course_id = s.course_id
WHERE e.trainee_id = trainee_id;

--- Count how many courses the trainee is enrolled in ---
SELECT COUNT(*) AS course_count
FROM Enrollment
WHERE trainee_id = trainee_id;

--- Show course titles, trainer names, and time slots the trainee is attending ---
SELECT c.title, t.name_t AS trainer_name, s.time_slot
FROM Enrollment e
JOIN Schedule s ON e.course_id = s.course_id
JOIN Course c ON s.course_id = c.course_id
JOIN Trainer t ON s.trainer_id = t.trainer_id
WHERE e.trainee_id = 1;


    --- Trainer Perspective ---
--- List all courses the trainer is assigned to ---
SELECT DISTINCT c.title
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
WHERE s.trainer_id = 1;

--- Show upcoming sessions (with dates and time slots) ---
SELECT c.title, s.start_date, s.end_date, s.time_slot
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
WHERE s.trainer_id = 1 AND s.start_date > GETDATE();

--- See how many trainees are enrolled in each of your courses ---
SELECT c.title, COUNT(e.trainee_id) AS num_trainees
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
LEFT JOIN Enrollment e ON s.course_id = e.course_id
WHERE s.trainer_id = 1
GROUP BY c.title;

--- List names and emails of trainees in each of your courses ---
SELECT c.title, t.Tname, t.email
FROM Schedule s
JOIN Enrollment e ON s.course_id = e.course_id
JOIN Trainee t ON e.trainee_id = t.trainee_id
JOIN Course c ON s.course_id = c.course_id
WHERE s.trainer_id = 1;

--- Show the trainer's contact info and assigned courses ---
SELECT t.name_t, t.phone, t.email, c.title
FROM Trainer t
JOIN Schedule s ON t.trainer_id = s.trainer_id
JOIN Course c ON s.course_id = c.course_id
WHERE t.trainer_id = 1;

--- Count the number of courses the trainer teaches ---
SELECT COUNT(DISTINCT course_id) AS course_count
FROM Schedule
WHERE trainer_id = 1;

    --- Admin Perspective ---

--- Add a new course ---
INSERT INTO Course (course_id, title, category, duration_hours, c_Level)
VALUES (5, 'AI Fundamentals', 'AI', 30, 'Intermediate');

--- Create a new schedule for a trainer ---
INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot)
VALUES (5, 5, 3, '2025-08-01', '2025-08-10', 'Evening');

--- View all trainee enrollments with course title and schedule info ---
SELECT t.Tname, c.title, s.start_date, s.time_slot
FROM Enrollment e
JOIN Trainee t ON e.trainee_id = t.trainee_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id;

--- Show how many courses each trainer is assigned to ---
SELECT t.name_t, COUNT(DISTINCT s.course_id) AS course_count
FROM Trainer t
LEFT JOIN Schedule s ON t.trainer_id = s.trainer_id
GROUP BY t.name_t;

--- List all trainees enrolled in "Data Basics" ---
SELECT t.Tname, t.email
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Trainee t ON e.trainee_id = t.trainee_id
WHERE c.title = 'Data Basics';

--- Identify the course with the highest number of enrollments ---
SELECT TOP 1 c.title, COUNT(e.trainee_id) AS enrollment_count
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
GROUP BY c.title
ORDER BY enrollment_count DESC; 

--- Display all schedules sorted by start date ---
SELECT *
FROM Schedule
ORDER BY start_date ASC;