-- Populate Dim_Date Table

DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate   DATE = '2028-12-31';

WHILE @StartDate <= @EndDate
BEGIN

    INSERT INTO Dim_Date
    (
        DateID,
        FullDate,
        DayNumber,
        DayName,
        MonthNumber,
        MonthName,
        QuarterNumber,
        YearNumber
    )
    VALUES
    (
        CONVERT(INT, FORMAT(@StartDate,'yyyyMMdd')),
        @StartDate,
        DAY(@StartDate),
        DATENAME(WEEKDAY,@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH,@StartDate),
        DATEPART(QUARTER,@StartDate),
        YEAR(@StartDate)
    );

    SET @StartDate = DATEADD(DAY,1,@StartDate);

END;


