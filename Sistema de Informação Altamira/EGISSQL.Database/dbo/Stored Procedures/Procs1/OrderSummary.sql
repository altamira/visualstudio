


CREATE PROCEDURE OrderSummary @MaxQuantity INT OUTPUT AS
-- SELECT to return a result set summarizing
-- employee sales.
SELECT Ord.EmployeeID, SummSales = SUM(OrDet.UnitPrice * OrDet.Quantity)
FROM Orders AS Ord
     JOIN [Order Details] AS OrDet ON (Ord.OrderID = OrDet.OrderID)
GROUP BY Ord.EmployeeID
ORDER BY Ord.EmployeeID

-- SELECT to fill the output parameter with the
-- maximum quantity from Order Details.
SELECT @MaxQuantity = MAX(Quantity) FROM [Order Details]

-- Return the number of all items ordered.
RETURN (SELECT SUM(Quantity) FROM [Order Details])

