-- Archived Products Table
-- Active Product Table

-- Customer Information Table
-- Historical 5-Year Customer Churn Data
-- Rolling 5-Year Customer Churn Data

-- Historical 5-Year Sales Orders Table
-- Rolling 5-Year Sales Orders Table

-- Historical 5-Year Sales Order Lines Table
-- Rolling 5-Year Sales Order Lines Table

-- Historical Payments Table
-- Rolling 5-Year Payments Table

-- Archived Product Review Data
-- Product Review Data

-- Historical Promotion Data
-- Active Promotion Data

-- Historical Shipment Data
-- Rolling 5-Year Shipping Data


-- Date Table
-- Create a new table named DateTable
CREATE TABLE DateTable (
    DateKey DATE PRIMARY KEY,
    DateFull TEXT,
    Year INT,
    Month INT,
    MonthName VARCHAR(20),
    Quarter INT,
    QuarterName VARCHAR(10),
    DayOfMonth INT,
    DayOfWeek INT,
    DayOfWeekName VARCHAR(20),
    IsWeekend BIT,
    IsHoliday BIT
);

-- Insert data into the DateTable using a recursive CTE to generate dates
WITH DateRange AS (
    SELECT CAST('2019-01-01' AS DATE) AS DateKey
    UNION ALL
    SELECT DATEADD(DAY, 1, DateKey) -- Increment DateKey by 1 day
    FROM DateRange
    WHERE DateKey < GETDATE() -- Use GETDATE() to get current date
)
INSERT INTO DateTable (DateKey, DateFull, Year, Month, MonthName, Quarter, QuarterName, DayOfMonth, DayOfWeek, DayOfWeekName, IsWeekend, IsHoliday)
SELECT
    DateKey,
    CONVERT(VARCHAR, DateKey, 112) AS DateFull,
    YEAR(DateKey) AS Year,
    MONTH(DateKey) AS Month,
    DATENAME(MONTH, DateKey) AS MonthName,
    DATEPART(QUARTER, DateKey) AS Quarter,
    'Q' + CAST(DATEPART(QUARTER, DateKey) AS VARCHAR) AS QuarterName,
    DAY(DateKey) AS DayOfMonth,
    DATEPART(WEEKDAY, DateKey) AS DayOfWeek,
    DATENAME(WEEKDAY, DateKey) AS DayOfWeekName,
    CASE WHEN DATEPART(WEEKDAY, DateKey) IN (1, 7) THEN 1 ELSE 0 END AS IsWeekend,
    0 AS IsHoliday -- Adjust if you have holiday data to include
FROM DateRange
OPTION (MAXRECURSION 0); -- Allow unlimited recursion depth (use with caution)


