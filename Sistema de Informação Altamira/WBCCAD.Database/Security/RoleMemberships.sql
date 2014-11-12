EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ALTAMIRA\Administrador';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ALTAMIRA\Alessandro';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'gestao';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ALTAMIRA\marcelo.parra';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'wbccad';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'ALTAMIRA\marcelo.parra';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'wbccad';

