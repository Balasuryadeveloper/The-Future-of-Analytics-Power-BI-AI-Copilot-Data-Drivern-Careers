SET NOCOUNT ON;

DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN

    INSERT INTO Fact_Usage
    (
        SubscriberID,
        RegionID,
        UsageDateID,
        VoiceMinutes,
        SMSCount,
        DataUsageGB
    )
    SELECT TOP 1
           DS.SubscriberID,
           DS.RegionID,

           (
                SELECT TOP 1 DD.DateID
                FROM Dim_Date DD
                WHERE DD.FullDate >= DS.ActivationDate
                ORDER BY NEWID()
           ) AS UsageDateID,

           -- Voice Usage (10 to 500 minutes)
           CAST(
                10 + (ABS(CHECKSUM(NEWID())) % 491)
           AS DECIMAL(10,2)),

           -- SMS Usage (0 to 200 SMS)
           ABS(CHECKSUM(NEWID())) % 201,

           -- Data Usage (0.50 GB to 25.00 GB)
           CAST(
                (
                    (ABS(CHECKSUM(NEWID())) % 2451) + 50
                ) / 100.0
           AS DECIMAL(10,2))

    FROM Dim_Subscriber DS
    ORDER BY NEWID();

    SET @Counter += 1;

END;
