INSERT INTO Fact_Activation
(
    SubscriberID,
    RegionID,
    PlanID,
    ActivationDateID
)
SELECT
      DS.SubscriberID
    , DS.RegionID
    , DS.PlanID
    , DD.DateID
FROM Dim_Subscriber DS
INNER JOIN Dim_Date DD
    ON DS.ActivationDate = DD.FullDate;