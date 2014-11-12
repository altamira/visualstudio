CREATE TABLE [dbo].[Trigger_] (
    [cd_trigger]           INT           NOT NULL,
    [nm_trigger]           VARCHAR (60)  NOT NULL,
    [cd_autor]             INT           NOT NULL,
    [nm_arquivo_trigger]   VARCHAR (100) NOT NULL,
    [ds_trigger]           TEXT          NOT NULL,
    [cd_modulo]            INT           NOT NULL,
    [cd_tabela]            INT           NOT NULL,
    [dt_trigger]           DATETIME      NOT NULL,
    [dt_alteracao_trigger] DATETIME      NOT NULL,
    [cd_usuario]           INT           NOT NULL,
    [dt_usuario]           DATETIME      NOT NULL,
    CONSTRAINT [PK_Trigger_] PRIMARY KEY CLUSTERED ([cd_trigger] ASC) WITH (FILLFACTOR = 90)
);

