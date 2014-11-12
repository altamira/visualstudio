CREATE TABLE [dbo].[Meta_Objetivo_Indicador] (
    [cd_meta]                  INT          NOT NULL,
    [cd_indicador]             INT          NULL,
    [vl_fator_meta_indicador]  FLOAT (53)   NULL,
    [qt_padrao_meta_indicador] FLOAT (53)   NULL,
    [cd_usuario_responsavel]   INT          NULL,
    [nm_obs_meta_indicador]    VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Meta_Objetivo_Indicador] PRIMARY KEY CLUSTERED ([cd_meta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Objetivo_Indicador_Usuario] FOREIGN KEY ([cd_usuario_responsavel]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

