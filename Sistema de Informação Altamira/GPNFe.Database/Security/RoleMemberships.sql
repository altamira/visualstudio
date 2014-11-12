EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ALTAMIRA\Administrador';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ALTAMIRA\Alessandro';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'interclick';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'interclick';

