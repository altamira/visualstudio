CREATE TABLE [dbo].[Usuario_Aprovacao] (
    [cd_usuario_aprovado]   INT          NOT NULL,
    [cd_usuario_autorizado] INT          NOT NULL,
    [dt_inicio]             DATETIME     NULL,
    [dt_final]              DATETIME     NULL,
    [nm_obs_aprovacao]      VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_tipo_aprovacao]     INT          NULL,
    [cd_tipo_ausencia]      INT          NULL,
    CONSTRAINT [PK_Usuario_Aprovacao] PRIMARY KEY CLUSTERED ([cd_usuario_aprovado] ASC, [cd_usuario_autorizado] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Aprovacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

