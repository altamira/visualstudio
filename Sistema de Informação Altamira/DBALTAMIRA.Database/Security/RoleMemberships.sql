EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ALTAMIRA\Alessandro';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'dbaltamira';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'dbaltamira';

