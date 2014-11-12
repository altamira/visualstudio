CREATE TABLE [dbo].[PRE_TipoMP] (
    [tpmp_Codigo]    NVARCHAR (3)  NOT NULL,
    [tpmp_Descrição] NVARCHAR (30) NULL,
    CONSTRAINT [PK_PRE_TipoMP] PRIMARY KEY NONCLUSTERED ([tpmp_Codigo] ASC) WITH (FILLFACTOR = 90)
);

