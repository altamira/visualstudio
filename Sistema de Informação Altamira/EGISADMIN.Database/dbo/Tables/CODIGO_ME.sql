CREATE TABLE [dbo].[CODIGO_ME] (
    [nm_tabela]  VARCHAR (100) NULL,
    [cd_atual]   INT           NOT NULL,
    [sg_status]  CHAR (1)      NULL,
    [cd_tabela]  INT           NULL,
    [cd_usuario] INT           NULL,
    [dt_usuario] DATETIME      NULL,
    CONSTRAINT [PK_CODIGO_ME] PRIMARY KEY CLUSTERED ([cd_atual] ASC) WITH (FILLFACTOR = 90)
);

