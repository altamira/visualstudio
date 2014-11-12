CREATE TABLE [dbo].[CODIGO_PV] (
    [nm_tabela]  VARCHAR (100) NOT NULL,
    [cd_atual]   INT           NOT NULL,
    [sg_status]  CHAR (1)      NOT NULL,
    [cd_tabela]  INT           NULL,
    [cd_usuario] INT           NULL,
    [dt_usuario] DATETIME      NULL,
    CONSTRAINT [PK_CODIGO_PV] PRIMARY KEY CLUSTERED ([nm_tabela] ASC, [cd_atual] ASC) WITH (FILLFACTOR = 90)
);

