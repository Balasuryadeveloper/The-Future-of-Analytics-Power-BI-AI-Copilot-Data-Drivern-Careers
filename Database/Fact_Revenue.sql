SET NOCOUNT ON;

DECLARE @Counter INT = 1;

WHILE @Counter <= 2000
BEGIN

    INSERT INTO Fact_Revenue
    (
        SubscriberID,
        RegionID,
        DateID,
        RevenueAmount
    )
    SELECT TOP 1
           DS.SubscriberID,
           DS.RegionID,

           (
               SELECT TOP 1 DD.DateID
               FROM Dim_Date DD
               WHERE DD.FullDate >= DS.ActivationDate
               ORDER BY NEWID()
           ),

           CAST
           (
               (
                   CASE DS.PlanID
                       WHEN 1 THEN 199
                       WHEN 2 THEN 299
                       WHEN 3 THEN 499
                       WHEN 4 THEN 799
                       WHEN 5 THEN 399
                       WHEN 6 THEN 699
                       WHEN 7 THEN 999
                       WHEN 8 THEN 99
                       WHEN 9 THEN 149
                       WHEN 10 THEN 249
                       ELSE 199
                   END
               )
               +
               (ABS(CHECKSUM(NEWID())) % 100)
           AS DECIMAL(12,2))

    FROM Dim_Subscriber DS
    ORDER BY NEWID();

    SET @Counter += 1;

END;
