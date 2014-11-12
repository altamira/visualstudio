CREATE TABLE [dbo].[FA_Cfop] (
    [facf_Codigo]       SMALLINT     NOT NULL,
    [facf_Completa]     SMALLINT     NOT NULL,
    [facf_Descricao]    VARCHAR (40) NOT NULL,
    [facf_Faturamento]  CHAR (1)     NULL,
    [facf_CfopCompleto] VARCHAR (10) NULL,
    [facf_Lock]         BINARY (8)   NULL,
    CONSTRAINT [PK_FA_Cfop] PRIMARY KEY NONCLUSTERED ([facf_Codigo] ASC, [facf_Completa] ASC) WITH (FILLFACTOR = 90)
);

