CREATE DATABASE MVNO_Analysis;

USE MVNO_Analysis;

CREATE TABLE Dim_Date
(
    DateID INT PRIMARY KEY,
    FullDate DATE,
    DayNumber INT,
    DayName VARCHAR(20),
    MonthNumber INT,
    MonthName VARCHAR(20),
    QuarterNumber INT,
    YearNumber INT
);

CREATE TABLE Dim_Subscriber
(
    SubscriberID INT IDENTITY(1,1) PRIMARY KEY,
    MobileNumber VARCHAR(15),
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    RegionID INT,
    PlanID INT,
    ActivationDate DATE,
    SubscriberStatus VARCHAR(20)
);

CREATE TABLE Dim_Plan
(
    PlanID INT IDENTITY(1,1) PRIMARY KEY,
    PlanName VARCHAR(100),
    PlanType VARCHAR(50),
    PlanPrice DECIMAL(10,2),
    ValidityDays INT
);

CREATE TABLE Dim_Region
(
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    RegionName VARCHAR(50),
    StateName VARCHAR(50),
    CircleName VARCHAR(50)
);

CREATE TABLE Fact_Activation
(
    ActivationID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    RegionID INT,
    PlanID INT,
    ActivationDateID INT,

    FOREIGN KEY (SubscriberID) REFERENCES Dim_Subscriber(SubscriberID),
    FOREIGN KEY (RegionID) REFERENCES Dim_Region(RegionID),
    FOREIGN KEY (PlanID) REFERENCES Dim_Plan(PlanID),
    FOREIGN KEY (ActivationDateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE Fact_Recharge
(
    RechargeID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    PlanID INT,
    RegionID INT,
    RechargeDateID INT,
    RechargeAmount DECIMAL(10,2),

    FOREIGN KEY (SubscriberID) REFERENCES Dim_Subscriber(SubscriberID),
    FOREIGN KEY (PlanID) REFERENCES Dim_Plan(PlanID),
    FOREIGN KEY (RegionID) REFERENCES Dim_Region(RegionID),
    FOREIGN KEY (RechargeDateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE Fact_Revenue
(
    RevenueID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    RegionID INT,
    DateID INT,
    RevenueAmount DECIMAL(12,2),

    FOREIGN KEY (SubscriberID) REFERENCES Dim_Subscriber(SubscriberID),
    FOREIGN KEY (RegionID) REFERENCES Dim_Region(RegionID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE Fact_Usage
(
    UsageID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    RegionID INT,
    UsageDateID INT,
    VoiceMinutes DECIMAL(10,2),
    SMSCount INT,
    DataUsageGB DECIMAL(10,2),

    FOREIGN KEY (SubscriberID) REFERENCES Dim_Subscriber(SubscriberID),
    FOREIGN KEY (RegionID) REFERENCES Dim_Region(RegionID),
    FOREIGN KEY (UsageDateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE Fact_Churn
(
    ChurnID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    RegionID INT,
    ChurnDateID INT,
    ChurnReason VARCHAR(100),

    FOREIGN KEY (SubscriberID) REFERENCES Dim_Subscriber(SubscriberID),
    FOREIGN KEY (RegionID) REFERENCES Dim_Region(RegionID),
    FOREIGN KEY (ChurnDateID) REFERENCES Dim_Date(DateID)
);
