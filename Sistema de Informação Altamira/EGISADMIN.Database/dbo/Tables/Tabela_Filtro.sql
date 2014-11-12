CREATE TABLE [dbo].[Tabela_Filtro] (
    [cd_tabela]              INT          NOT NULL,
    [cd_tabela_filtro]       INT          NOT NULL,
    [cd_atributo]            INT          NULL,
    [ic_tipo_filtro]         CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ds_sql_filtro_atributo] TEXT         NULL,
    [nm_obs_filtro_atributo] VARCHAR (40) NULL,
    CONSTRAINT [PK_Tabela_Filtro] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_tabela_filtro] ASC) WITH (FILLFACTOR = 90)
);

