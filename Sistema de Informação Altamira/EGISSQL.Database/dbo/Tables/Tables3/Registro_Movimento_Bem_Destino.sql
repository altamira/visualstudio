CREATE TABLE [dbo].[Registro_Movimento_Bem_Destino] (
    [cd_registro_bem]    INT      NOT NULL,
    [cd_planta]          INT      NULL,
    [cd_localizacao_bem] INT      NULL,
    [cd_area_risco]      INT      NULL,
    [cd_departamento]    INT      NULL,
    [cd_centro_custo]    INT      NULL,
    [cd_conta]           INT      NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Registro_Movimento_Bem_Destino] PRIMARY KEY CLUSTERED ([cd_registro_bem] ASC) WITH (FILLFACTOR = 90)
);

