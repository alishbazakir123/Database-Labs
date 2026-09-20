-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 20, 2026 at 06:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cargo_rentals`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegisterNewRental` (IN `p_RentalID` VARCHAR(20), IN `p_CustomerID` INT, IN `p_VehicleNumber` VARCHAR(20), IN `p_RentalDate` DATE, IN `p_ReturnDate` DATE)   BEGIN
    DECLARE v_DailyRate DECIMAL(10,2);
    DECLARE v_Days INT;
    DECLARE v_TotalCharge DECIMAL(10,2);
    DECLARE v_Status VARCHAR(20);

    SELECT Status, DailyRate INTO v_Status, v_DailyRate 
    FROM Vehicles WHERE VehicleNumber = p_VehicleNumber;

    IF v_Status = 'Rented' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Operation Halted: This vehicle is already out on lease!';
    ELSE
        INSERT INTO Rentals (RentalID, CustomerID, VehicleNumber, RentalDate, ReturnDate)
        VALUES (p_RentalID, p_CustomerID, p_VehicleNumber, p_RentalDate, p_ReturnDate);

        IF p_ReturnDate IS NOT NULL THEN
            SET v_Days = DATEDIFF(p_ReturnDate, p_RentalDate);
            IF v_Days = 0 THEN SET v_Days = 1; END IF;
            SET v_TotalCharge = v_Days * v_DailyRate;
            
            INSERT INTO Payments (RentalID, PaymentAmount) 
            VALUES (p_RentalID, v_TotalCharge);
        END IF;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CustomerID` int(11) NOT NULL,
  `CustomerName` varchar(100) NOT NULL,
  `CustomerPhone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CustomerID`, `CustomerName`, `CustomerPhone`) VALUES
(1, 'Ali Khan', '0300-1234567'),
(2, 'Sara Ahmed', '0321-7654321'),
(3, 'Omer Farooq', '0333-9876543'),
(4, 'Zainab Bibi', '0345-1122334');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `PaymentID` int(11) NOT NULL,
  `RentalID` varchar(20) NOT NULL,
  `PaymentAmount` decimal(10,2) NOT NULL CHECK (`PaymentAmount` >= 0),
  `PaymentDate` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`PaymentID`, `RentalID`, `PaymentAmount`, `PaymentDate`) VALUES
(1, 'R001', 15000.00, '2026-09-20 14:37:40'),
(2, 'R002', 12000.00, '2026-09-20 14:37:40'),
(3, 'R005', 12000.00, '2026-09-20 15:08:27');

-- --------------------------------------------------------

--
-- Table structure for table `rentals`
--

CREATE TABLE `rentals` (
  `RentalID` varchar(20) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `VehicleNumber` varchar(20) NOT NULL,
  `RentalDate` date NOT NULL,
  `ReturnDate` date DEFAULT NULL
) ;

--
-- Dumping data for table `rentals`
--

INSERT INTO `rentals` (`RentalID`, `CustomerID`, `VehicleNumber`, `RentalDate`, `ReturnDate`) VALUES
('R001', 1, 'ABC-123', '2026-09-01', '2026-09-04'),
('R002', 2, 'LMN-456', '2026-09-10', '2026-09-12'),
('R003', 1, 'ABC-123', '2026-09-15', NULL),
('R005', 2, 'LMN-456', '2026-09-20', '2026-09-22');

--
-- Triggers `rentals`
--
DELIMITER $$
CREATE TRIGGER `After_Rental_Insert` AFTER INSERT ON `rentals` FOR EACH ROW BEGIN
    UPDATE Vehicles 
    SET Status = 'Rented' 
    WHERE VehicleNumber = NEW.VehicleNumber;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `VehicleNumber` varchar(20) NOT NULL,
  `VehicleModel` varchar(50) NOT NULL,
  `DailyRate` decimal(10,2) NOT NULL CHECK (`DailyRate` > 0),
  `Status` varchar(20) DEFAULT 'Available' CHECK (`Status` in ('Available','Rented','Maintenance'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`VehicleNumber`, `VehicleModel`, `DailyRate`, `Status`) VALUES
('ABC-123', 'Toyota Corolla', 5000.00, 'Rented'),
('LMN-456', 'Honda Civic', 6000.00, 'Rented'),
('XYZ-789', 'Suzuki Alto', 3000.00, 'Available');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_consolidated_rental_report`
-- (See below for the actual view)
--
CREATE TABLE `view_consolidated_rental_report` (
`RentalID` varchar(20)
,`CustomerName` varchar(100)
,`CustomerPhone` varchar(20)
,`VehicleNumber` varchar(20)
,`VehicleModel` varchar(50)
,`RentalDate` date
,`ReturnDate` date
,`PaidAmount` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_consolidated_rental_report`
--
DROP TABLE IF EXISTS `view_consolidated_rental_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_consolidated_rental_report`  AS SELECT `r`.`RentalID` AS `RentalID`, `c`.`CustomerName` AS `CustomerName`, `c`.`CustomerPhone` AS `CustomerPhone`, `v`.`VehicleNumber` AS `VehicleNumber`, `v`.`VehicleModel` AS `VehicleModel`, `r`.`RentalDate` AS `RentalDate`, `r`.`ReturnDate` AS `ReturnDate`, coalesce(`p`.`PaymentAmount`,0.00) AS `PaidAmount` FROM (((`rentals` `r` join `customers` `c` on(`r`.`CustomerID` = `c`.`CustomerID`)) join `vehicles` `v` on(`r`.`VehicleNumber` = `v`.`VehicleNumber`)) left join `payments` `p` on(`r`.`RentalID` = `p`.`RentalID`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`),
  ADD UNIQUE KEY `CustomerPhone` (`CustomerPhone`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`PaymentID`),
  ADD KEY `RentalID` (`RentalID`);

--
-- Indexes for table `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`RentalID`),
  ADD KEY `idx_rentals_customer` (`CustomerID`),
  ADD KEY `idx_rentals_active_cars` (`VehicleNumber`,`ReturnDate`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`VehicleNumber`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`RentalID`) REFERENCES `rentals` (`RentalID`) ON DELETE CASCADE;

--
-- Constraints for table `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE CASCADE,
  ADD CONSTRAINT `rentals_ibfk_2` FOREIGN KEY (`VehicleNumber`) REFERENCES `vehicles` (`VehicleNumber`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
