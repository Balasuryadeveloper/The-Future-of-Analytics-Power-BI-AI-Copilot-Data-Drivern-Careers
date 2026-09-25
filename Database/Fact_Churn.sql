;WITH ChurnSubscribers AS
(
    SELECT TOP (120)
           DS.SubscriberID,
           DS.RegionID,
           DS.ActivationDate
    FROM Dim_Subscriber DS
    ORDER BY NEWID()
)
INSERT INTO Fact_Churn
(
    SubscriberID,
    RegionID,
    ChurnDateID,
    ChurnReason
)
SELECT
       CS.SubscriberID,
       CS.RegionID,

       DD.DateID,

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

FROM ChurnSubscribers CS

CROSS APPLY
(
    SELECT TOP 1 DD.DateID
    FROM Dim_Date DD
    WHERE DD.FullDate >= CS.ActivationDate
      AND DD.FullDate <= '2026-09-30'
    ORDER BY NEWID()
) DD;
``
