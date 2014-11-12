CREATE TABLE [dbo].[Tipo_Filtro_Pesquisa] (
    [cd_tipo_filtro_pesquisa] INT          NOT NULL,
    [nm_tipo_filtro_pesquisa] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_filtro_pesquisa] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_tabela]               INT          NOT NULL,
    [ds_scriptsql_tbl_filtro] TEXT         COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL
);

