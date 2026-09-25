;WITH Numbers AS
(
    SELECT TOP (2000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects A
    CROSS JOIN sys.all_objects B
)
INSERT INTO Fact_Revenue
(
    SubscriberID,
    RegionID,
    DateID,
    RevenueAmount
)
SELECT
       DS.SubscriberID,
       DS.RegionID,

       DD.DateID,

       CAST
       (
           CASE
               WHEN DS.PlanID IN (1,2)
                    THEN 150 + ABS(CHECKSUM(NEWID())) % 200

               WHEN DS.PlanID IN (3,4)
                    THEN 450 + ABS(CHECKSUM(NEWID())) % 400

               WHEN DS.PlanID IN (5,6,7)
                    THEN 600 + ABS(CHECKSUM(NEWID())) % 600

               ELSE
                    100 + ABS(CHECKSUM(NEWID())) % 150
           END
       AS DECIMAL(12,2))

FROM Numbers N

INNER JOIN Dim_Subscriber DS
    ON DS.SubscriberID =
       ((N.N - 1) % (SELECT COUNT(*) FROM Dim_Subscriber)) + 1

CROSS APPLY
(
    SELECT TOP 1 DD.DateID
    FROM Dim_Date DD
    WHERE DD.FullDate >= DS.ActivationDate
      AND DD.FullDate <= '2026-09-30'
    ORDER BY NEWID()
) DD;
