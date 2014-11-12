CREATE TABLE [dbo].[Usuario_Autorizacao_Aprovacao] (
    [cd_usuario_aut_aprovado] INT          NOT NULL,
    [cd_usuario_autorizado]   INT          NOT NULL,
    [nm_obs_usuario_aut]      VARCHAR (40) NULL,
    [cd_tipo_aprovacao]       INT          NULL,
    [dt_inicio_autorizacao]   DATETIME     NULL,
    [dt_final_autorizacao]    DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tipo_ausencia]        INT          NULL,
    CONSTRAINT [PK_Usuario_Autorizacao_Aprovacao] PRIMARY KEY CLUSTERED ([cd_usuario_autorizado] ASC, [cd_usuario_aut_aprovado] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Autorizacao_Aprovacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

