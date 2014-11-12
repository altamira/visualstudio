CREATE TABLE [dbo].[Comissao_Consistencia] (
    [dt_base_comissao]         DATETIME NOT NULL,
    [ic_consistencia_comissao] CHAR (1) NULL,
    CONSTRAINT [PK_Comissao_consistencia] PRIMARY KEY CLUSTERED ([dt_base_comissao] ASC) WITH (FILLFACTOR = 90)
);

