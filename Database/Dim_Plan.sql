INSERT INTO Dim_Plan
(
    PlanName,
    PlanType,
    PlanPrice,
    ValidityDays
)
VALUES

-- Prepaid Plans
('Smart Prepaid 199',      'Prepaid',   199.00, 28),
('Value Prepaid 299',      'Prepaid',   299.00, 28),
('Unlimited Prepaid 499',  'Prepaid',   499.00, 56),
('Premium Prepaid 799',    'Prepaid',   799.00, 84),

-- Postpaid Plans
('Postpaid Silver',        'Postpaid',  399.00, 30),
('Postpaid Gold',          'Postpaid',  699.00, 30),
('Postpaid Platinum',      'Postpaid',  999.00, 30),

-- Data Plans
('Data Booster 99',        'Data Pack',  99.00, 15),
('Data Booster 149',       'Data Pack', 149.00, 28),

-- Special Plan
('Student Combo 249',      'Student',   249.00, 30);