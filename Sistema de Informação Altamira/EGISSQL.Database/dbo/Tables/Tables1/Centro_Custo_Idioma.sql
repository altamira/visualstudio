CREATE TABLE [dbo].[Centro_Custo_Idioma] (
    [cd_centro_custo]        INT          NOT NULL,
    [cd_idioma]              INT          NOT NULL,
    [nm_centro_custo_idioma] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Centro_Custo_Idioma] PRIMARY KEY CLUSTERED ([cd_centro_custo] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

