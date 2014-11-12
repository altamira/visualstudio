CREATE RULE [dbo].[ck_Cep]
    AS @col BETWEEN 00100000 AND 99999999;


GO
EXECUTE sp_bindrule @rulename = N'[dbo].[ck_Cep]', @objname = N'[dbo].[tp_CEP]';

