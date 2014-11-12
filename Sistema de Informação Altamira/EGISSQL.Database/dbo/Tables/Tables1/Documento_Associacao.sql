CREATE TABLE [dbo].[Documento_Associacao] (
    [cd_documento_associacao] INT          NOT NULL,
    [cd_documento_qualidade]  INT          NOT NULL,
    [cd_documento_filho]      INT          NOT NULL,
    [nm_obs_documento]        VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Documento_Associacao] PRIMARY KEY CLUSTERED ([cd_documento_associacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Associacao_Documento_Qualidade] FOREIGN KEY ([cd_documento_filho]) REFERENCES [dbo].[Documento_Qualidade] ([cd_documento_qualidade])
);

