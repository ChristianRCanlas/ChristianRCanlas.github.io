CREATE PROCEDURE dbo.InsertNextDate
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NextDate DATE;

    -- Calculate the next date to insert (tomorrow's date)
    SET @NextDate = DATEADD(DAY, 1, (SELECT MAX(DateKey) FROM DateTable));

    -- Ensure @NextDate does not exceed today's date
    IF @NextDate <= GETDATE()
    BEGIN
        -- Insert the next date into DateTable
        INSERT INTO DateTable (DateKey, DateFull, Year, Month, MonthName, Quarter, QuarterName, DayOfMonth, DayOfWeek, DayOfWeekName, IsWeekend, IsHoliday)
        SELECT
            @NextDate AS DateKey,
            CONVERT(VARCHAR, @NextDate, 112) AS DateFull,
            YEAR(@NextDate) AS Year,
            MONTH(@NextDate) AS Month,
            DATENAME(MONTH, @NextDate) AS MonthName,
            DATEPART(QUARTER, @NextDate) AS Quarter,
            'Q' + CAST(DATEPART(QUARTER, @NextDate) AS VARCHAR) AS QuarterName,
            DAY(@NextDate) AS DayOfMonth,
            DATEPART(WEEKDAY, @NextDate) AS DayOfWeek,
            DATENAME(WEEKDAY, @NextDate) AS DayOfWeekName,
            CASE WHEN DATEPART(WEEKDAY, @NextDate) IN (1, 7) THEN 1 ELSE 0 END AS IsWeekend,
            0 AS IsHoliday; -- Adjust if you have holiday data to include
    END;
END;
GO