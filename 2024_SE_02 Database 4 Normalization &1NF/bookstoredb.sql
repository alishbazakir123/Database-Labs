-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 18, 2026 at 09:43 PM
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
-- Database: `bookstoredb`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `BookID` varchar(10) NOT NULL,
  `BookTitle` varchar(100) DEFAULT NULL,
  `Publisher` varchar(50) DEFAULT NULL,
  `UnitPrice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `books_2nf`
--

CREATE TABLE `books_2nf` (
  `BookID` varchar(10) NOT NULL,
  `BookTitle` varchar(100) DEFAULT NULL,
  `Publisher` varchar(50) DEFAULT NULL,
  `UnitPrice` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books_2nf`
--

INSERT INTO `books_2nf` (`BookID`, `BookTitle`, `Publisher`, `UnitPrice`) VALUES
('B-1', 'SQL Basics', 'Pearson', 1200),
('B-2', 'Python 101', 'OReilly', 1500),
('B-3', 'Networks', 'Pearson', 1800);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CustID` varchar(10) NOT NULL,
  `CustName` varchar(50) DEFAULT NULL,
  `CustEmail` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orderbook_1nf`
--

CREATE TABLE `orderbook_1nf` (
  `OrderID` varchar(10) NOT NULL,
  `OrderDate` date DEFAULT NULL,
  `CustID` varchar(10) DEFAULT NULL,
  `CustName` varchar(50) DEFAULT NULL,
  `CustEmail` varchar(50) DEFAULT NULL,
  `BookID` varchar(10) NOT NULL,
  `BookTitle` varchar(100) DEFAULT NULL,
  `Publisher` varchar(50) DEFAULT NULL,
  `UnitPrice` int(11) DEFAULT NULL,
  `Qty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orderbook_1nf`
--

INSERT INTO `orderbook_1nf` (`OrderID`, `OrderDate`, `CustID`, `CustName`, `CustEmail`, `BookID`, `BookTitle`, `Publisher`, `UnitPrice`, `Qty`) VALUES
('O-501', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com', 'B-1', 'SQL Basics', 'Pearson', 1200, 1),
('O-501', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com', 'B-2', 'Python 101', 'OReilly', 1500, 2),
('O-502', '2026-04-03', 'C-12', 'Areeba', 'areeba@x.com', 'B-1', 'SQL Basics', 'Pearson', 1200, 3),
('O-503', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com', 'B-2', 'Python 101', 'OReilly', 1500, 1),
('O-503', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com', 'B-3', 'Networks', 'Pearson', 1800, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `OrderID` varchar(10) NOT NULL,
  `BookID` varchar(10) NOT NULL,
  `Qty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails_2nf`
--

CREATE TABLE `orderdetails_2nf` (
  `OrderID` varchar(10) NOT NULL,
  `BookID` varchar(10) NOT NULL,
  `Qty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orderdetails_2nf`
--

INSERT INTO `orderdetails_2nf` (`OrderID`, `BookID`, `Qty`) VALUES
('O-501', 'B-1', 1),
('O-501', 'B-2', 2),
('O-502', 'B-1', 3),
('O-503', 'B-2', 1),
('O-503', 'B-3', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `OrderID` varchar(10) NOT NULL,
  `OrderDate` date DEFAULT NULL,
  `CustID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders_2nf`
--

CREATE TABLE `orders_2nf` (
  `OrderID` varchar(10) NOT NULL,
  `OrderDate` date DEFAULT NULL,
  `CustID` varchar(10) DEFAULT NULL,
  `CustName` varchar(50) DEFAULT NULL,
  `CustEmail` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders_2nf`
--

INSERT INTO `orders_2nf` (`OrderID`, `OrderDate`, `CustID`, `CustName`, `CustEmail`) VALUES
('O-501', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com'),
('O-502', '2026-04-03', 'C-12', 'Areeba', 'areeba@x.com'),
('O-503', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`BookID`);

--
-- Indexes for table `books_2nf`
--
ALTER TABLE `books_2nf`
  ADD PRIMARY KEY (`BookID`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustID`);

--
-- Indexes for table `orderbook_1nf`
--
ALTER TABLE `orderbook_1nf`
  ADD PRIMARY KEY (`OrderID`,`BookID`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`OrderID`,`BookID`),
  ADD KEY `BookID` (`BookID`);

--
-- Indexes for table `orderdetails_2nf`
--
ALTER TABLE `orderdetails_2nf`
  ADD PRIMARY KEY (`OrderID`,`BookID`),
  ADD KEY `BookID` (`BookID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `CustID` (`CustID`);

--
-- Indexes for table `orders_2nf`
--
ALTER TABLE `orders_2nf`
  ADD PRIMARY KEY (`OrderID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`);

--
-- Constraints for table `orderdetails_2nf`
--
ALTER TABLE `orderdetails_2nf`
  ADD CONSTRAINT `orderdetails_2nf_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders_2nf` (`OrderID`),
  ADD CONSTRAINT `orderdetails_2nf_ibfk_2` FOREIGN KEY (`BookID`) REFERENCES `books_2nf` (`BookID`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustID`) REFERENCES `customers` (`CustID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
