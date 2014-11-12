CREATE TABLE [dbo].[Codigo] (
    [nm_tabela]  VARCHAR (100) NOT NULL,
    [cd_atual]   INT           NOT NULL,
    [sg_status]  CHAR (1)      NOT NULL,
    [cd_tabela]  INT           NULL,
    [cd_usuario] INT           NULL,
    [dt_usuario] DATETIME      NULL,
    CONSTRAINT [PK_Codigo] PRIMARY KEY CLUSTERED ([nm_tabela] ASC, [cd_atual] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ID_Codigo_Tabela]
    ON [dbo].[Codigo]([nm_tabela] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ID_Codigo_Status]
    ON [dbo].[Codigo]([sg_status] ASC) WITH (FILLFACTOR = 90);

