CREATE TABLE [dbo].[Funcao_SQL] (
    [cd_funcao_sql]     INT           NOT NULL,
    [nm_funcao_sql]     VARCHAR (100) NULL,
    [nm_sql_funcao_sql] VARCHAR (100) NULL,
    [ds_funcao_sql]     TEXT          NULL,
    [cd_modulo]         INT           NULL,
    [cd_autor]          INT           NULL,
    [cd_usuario]        INT           NULL,
    [dt_usuario]        DATETIME      NULL,
    CONSTRAINT [PK_Funcao_SQL] PRIMARY KEY CLUSTERED ([cd_funcao_sql] ASC) WITH (FILLFACTOR = 90)
);

