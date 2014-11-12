CREATE TABLE [dbo].[Registro_Movimento_Bem] (
    [cd_registro_bem]         INT      NOT NULL,
    [dt_registro_bem]         DATETIME NULL,
    [cd_tipo_movimento_bem]   INT      NULL,
    [ds_registro_bem]         TEXT     NULL,
    [cd_planta]               INT      NULL,
    [cd_localizacao_bem]      INT      NULL,
    [cd_area_risco]           INT      NULL,
    [cd_departamento]         INT      NULL,
    [cd_centro_custo]         INT      NULL,
    [cd_conta]                INT      NULL,
    [cd_motivo_movimento_bem] INT      NULL,
    [cd_usuario_aprovacao]    INT      NULL,
    [dt_aprovacao_registro]   DATETIME NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Registro_Movimento_Bem] PRIMARY KEY CLUSTERED ([cd_registro_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Movimento_Bem_Motivo_Movimento_Bem] FOREIGN KEY ([cd_motivo_movimento_bem]) REFERENCES [dbo].[Motivo_Movimento_Bem] ([cd_motivo_movimento_bem])
);

