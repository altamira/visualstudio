CREATE RULE [dbo].[ck_DDI]
    AS @col BETWEEN 00 AND 99;


GO
EXECUTE sp_bindrule @rulename = N'[dbo].[ck_DDI]', @objname = N'[dbo].[Operadora_Telefonia].[cd_servico_operadora]';

