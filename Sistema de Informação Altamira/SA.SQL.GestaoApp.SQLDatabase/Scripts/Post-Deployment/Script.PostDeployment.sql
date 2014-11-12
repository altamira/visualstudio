/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

:r .\Security.User.sql
:r .\Attendance.Status.Group.sql
:r .\Attendance.Type.Group.sql
:r .\Attendance.Status.sql
:r .\Attendance.Type.sql
:r .\Attendance.Product.sql
:r .\Contact.Media.sql
:r .\Contact.FoneType.sql
:r .\Location.Country.sql
:r .\Location.State.sql
:r .\Location.City.sql
:r .\Sales.PurchaseType.sql
:r .\Sales.Vendor.sql

:r .\SMS.SendQueued.sql

--:r .\GPIMAC.sql
--:r .\Import.sql
