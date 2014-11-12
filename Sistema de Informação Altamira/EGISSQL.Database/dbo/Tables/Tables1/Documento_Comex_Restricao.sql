CREATE TABLE [dbo].[Documento_Comex_Restricao] (
    [cd_tipo_documento_comex]  INT          NOT NULL,
    [cd_campo_documento_comex] INT          NOT NULL,
    [ic_imprime]               CHAR (1)     NULL,
    [nm_obs_campo_restricao]   VARCHAR (50) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Documento_Comex_Restricao] PRIMARY KEY CLUSTERED ([cd_tipo_documento_comex] ASC, [cd_campo_documento_comex] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Comex_Restricao_Documento_Comex_Campo] FOREIGN KEY ([cd_campo_documento_comex]) REFERENCES [dbo].[Documento_Comex_Campo] ([cd_campo_documento_comex])
);

