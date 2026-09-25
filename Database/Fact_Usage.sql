;WITH Numbers AS
(
    SELECT TOP (3000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects A
    CROSS JOIN sys.all_objects B
)
INSERT INTO Fact_Usage
(
    SubscriberID,
    RegionID,
    UsageDateID,
    VoiceMinutes,
    SMSCount,
    DataUsageGB
)
SELECT
       DS.SubscriberID,
       DS.RegionID,

       DD.DateID,

       -- Voice Usage (10 to 500 Minutes)
       CAST
       (
           10 + (ABS(CHECKSUM(NEWID())) % 491)
       AS DECIMAL(10,2)
       ) AS VoiceMinutes,

       -- SMS Usage (0 to 200)
       ABS(CHECKSUM(NEWID())) % 201 AS SMSCount,

       -- Data Usage (0.50 GB to 25.00 GB)
       CAST
       (
           ((ABS(CHECKSUM(NEWID())) % 2451) + 50)
           / 100.0
       AS DECIMAL(10,2)
       ) AS DataUsageGB

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
