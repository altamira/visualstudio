CREATE TABLE [dbo].[Grafico_Usuario] (
    [cd_usuario_grafico]     INT          NOT NULL,
    [cd_grafico_usuario]     INT          NOT NULL,
    [nm_grafico_usuario]     VARCHAR (40) NULL,
    [cd_tipo_grafico]        INT          NULL,
    [cd_estilo_grafico]      INT          NULL,
    [cd_funcao_grafico]      INT          NULL,
    [cd_tipo_funcao_grafico] INT          NULL,
    [cd_modulo]              INT          NULL,
    [cd_menu]                INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Grafico_Usuario] PRIMARY KEY CLUSTERED ([cd_usuario_grafico] ASC, [cd_grafico_usuario] ASC) WITH (FILLFACTOR = 90)
);

