SET NOCOUNT ON;

DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN

    INSERT INTO Dim_Subscriber
    (
        MobileNumber,
        CustomerName,
        Gender,
        Age,
        City,
        State,
        RegionID,
        PlanID,
        ActivationDate,
        SubscriberStatus
    )
    VALUES
    (
        -- Mobile Number
        '9' + RIGHT('000000000' + CAST(@Counter AS VARCHAR(9)), 9),

        -- Customer Name
        'Subscriber_' + CAST(@Counter AS VARCHAR(10)),

        -- Gender
        CASE
            WHEN @Counter % 2 = 0 THEN 'Male'
            ELSE 'Female'
        END,

        -- Age
        18 + ABS(CHECKSUM(NEWID())) % 42,

        -- City
        CASE ABS(CHECKSUM(NEWID())) % 10
            WHEN 0 THEN 'Chennai'
            WHEN 1 THEN 'Bangalore'
            WHEN 2 THEN 'Hyderabad'
            WHEN 3 THEN 'Mumbai'
            WHEN 4 THEN 'Delhi'
            WHEN 5 THEN 'Pune'
            WHEN 6 THEN 'Kolkata'
            WHEN 7 THEN 'Coimbatore'
            WHEN 8 THEN 'Madurai'
            ELSE 'Salem'
        END,

        -- State
        CASE ABS(CHECKSUM(NEWID())) % 5
            WHEN 0 THEN 'Tamil Nadu'
            WHEN 1 THEN 'Karnataka'
            WHEN 2 THEN 'Telangana'
            WHEN 3 THEN 'Maharashtra'
            ELSE 'Delhi'
        END,

        -- RegionID
        1 + ABS(CHECKSUM(NEWID())) % 5,

        -- PlanID
        1 + ABS(CHECKSUM(NEWID())) % 10,

        -- Activation Date
        DATEADD
        (
            DAY,
            -ABS(CHECKSUM(NEWID())) % 730,
            GETDATE()
        ),

        -- Subscriber Status
        CASE ABS(CHECKSUM(NEWID())) % 100
            WHEN 0 THEN 'Churned'
            WHEN 1 THEN 'Inactive'
            WHEN 2 THEN 'Suspended'
            ELSE 'Active'
        END
    );

    SET @Counter += 1;

END;