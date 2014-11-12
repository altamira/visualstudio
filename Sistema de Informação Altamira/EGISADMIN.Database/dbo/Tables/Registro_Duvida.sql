CREATE TABLE [dbo].[Registro_Duvida] (
    [cd_registro_duvida]     INT          NOT NULL,
    [dt_registro_duvida]     DATETIME     NOT NULL,
    [cd_modulo]              INT          NULL,
    [cd_cliente_sistema]     INT          NULL,
    [cd_usuario_sistema]     INT          NULL,
    [cd_consultor]           INT          NULL,
    [cd_atividade]           INT          NULL,
    [ds_registro_duvida]     TEXT         NULL,
    [nm_obs_registro_duvida] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_tipo_duvida]         INT          NULL,
    CONSTRAINT [PK_Registro_Duvida] PRIMARY KEY CLUSTERED ([cd_registro_duvida] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Duvida_Atividade_Implantacao] FOREIGN KEY ([cd_atividade]) REFERENCES [dbo].[Atividade_Implantacao] ([cd_atividade]),
    CONSTRAINT [FK_Registro_Duvida_Tipo_Duvida] FOREIGN KEY ([cd_tipo_duvida]) REFERENCES [dbo].[Tipo_Duvida] ([cd_tipo_duvida])
);

