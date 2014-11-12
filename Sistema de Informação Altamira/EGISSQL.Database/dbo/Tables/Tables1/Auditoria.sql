CREATE TABLE [dbo].[Auditoria] (
    [cd_auditoria]           INT          NOT NULL,
    [dt_auditoria]           DATETIME     NULL,
    [cd_auditor]             INT          NULL,
    [cd_planta]              INT          NULL,
    [cd_area]                INT          NULL,
    [cd_usuario_responsavel] INT          NULL,
    [nm_obs_auditoria]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Auditoria] PRIMARY KEY CLUSTERED ([cd_auditoria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Auditoria_Usuario] FOREIGN KEY ([cd_usuario_responsavel]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

