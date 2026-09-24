SET NOCOUNT ON;

DECLARE @Counter INT = 1;

WHILE @Counter <= 120
BEGIN

    INSERT INTO Fact_Churn
    (
        SubscriberID,
        RegionID,
        ChurnDateID,
        ChurnReason
    )
    SELECT TOP 1
           DS.SubscriberID,
           DS.RegionID,

           (
                SELECT TOP 1 DD.DateID
                FROM Dim_Date DD
                WHERE DD.FullDate > DS.ActivationDate
                ORDER BY NEWID()
           ),

           CASE ABS(CHECKSUM(NEWID())) % 8
                WHEN 0 THEN 'Price Sensitivity'
                WHEN 1 THEN 'Network Issues'
                WHEN 2 THEN 'Better Competitor Offer'
                WHEN 3 THEN 'Coverage Problems'
                WHEN 4 THEN 'Poor Customer Service'
                WHEN 5 THEN 'Low Usage'
                WHEN 6 THEN 'Relocation'
                ELSE 'Personal Reason'
           END

    FROM Dim_Subscriber DS
    WHERE DS.SubscriberID NOT IN
    (
        SELECT SubscriberID
        FROM Fact_Churn
    )
    ORDER BY NEWID();

    SET @Counter += 1;

END;