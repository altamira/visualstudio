CREATE TABLE [dbo].[View_] (
    [cd_view]         INT           NOT NULL,
    [nm_titulo_view]  VARCHAR (40)  NOT NULL,
    [cd_usuario]      INT           NOT NULL,
    [dt_usuario]      DATETIME      NOT NULL,
    [cd_usuario_view] INT           NULL,
    [dt_alteracao]    DATETIME      NULL,
    [dt_criacao]      DATETIME      NULL,
    [ds_view]         TEXT          NULL,
    [nm_sql_view]     VARCHAR (80)  NULL,
    [nm_arquivo_view] VARCHAR (100) NULL,
    [cd_modulo]       INT           NULL,
    [cd_autor]        INT           NULL,
    CONSTRAINT [PK_View_] PRIMARY KEY CLUSTERED ([cd_view] ASC) WITH (FILLFACTOR = 90)
);

