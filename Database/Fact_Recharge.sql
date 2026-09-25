;WITH Numbers AS
(
    SELECT TOP (2000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Fact_Recharge
(
    SubscriberID,
    PlanID,
    RegionID,
    RechargeDateID,
    RechargeAmount
)
SELECT
       DS.SubscriberID,
       DS.PlanID,
       DS.RegionID,

       DD.DateID,

       CAST
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
           +
           (ABS(CHECKSUM(NEWID())) % 50)
       AS DECIMAL(10,2))

FROM Numbers N

INNER JOIN Dim_Subscriber DS
    ON DS.SubscriberID =
       ((N.N - 1) % (SELECT COUNT(*) FROM Dim_Subscriber)) + 1

CROSS APPLY
(
    SELECT TOP 1 DateID
    FROM Dim_Date DD
    WHERE DD.FullDate >= DS.ActivationDate
    ORDER BY NEWID()
) DD;
