CREATE TABLE [dbo].[Prioridade_Tabela] (
    [cd_prioridade_tabela]     INT          NOT NULL,
    [nm_prioridade_tabela]     VARCHAR (40) NULL,
    [sg_prioridade_tabela]     CHAR (10)    NULL,
    [ic_pad_prioridade_tabela] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [qt_prioridade_tabela]     INT          NULL,
    [ds_prioridade_tabela]     TEXT         NULL,
    CONSTRAINT [PK_Prioridade_Tabela] PRIMARY KEY CLUSTERED ([cd_prioridade_tabela] ASC) WITH (FILLFACTOR = 90)
);

