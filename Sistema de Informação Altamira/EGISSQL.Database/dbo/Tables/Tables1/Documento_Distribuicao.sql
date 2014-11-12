CREATE TABLE [dbo].[Documento_Distribuicao] (
    [cd_distribuicao_documento] INT          NOT NULL,
    [cd_documento_qualidade]    INT          NOT NULL,
    [cd_planta]                 INT          NULL,
    [cd_departamento]           INT          NULL,
    [cd_tipo_copia]             INT          NULL,
    [qt_copia_documento]        FLOAT (53)   NULL,
    [nm_obs_distribuicao]       VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Documento_Distribuicao] PRIMARY KEY CLUSTERED ([cd_distribuicao_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Distribuicao_Tipo_Copia_Documento] FOREIGN KEY ([cd_tipo_copia]) REFERENCES [dbo].[Tipo_Copia_Documento] ([cd_tipo_copia_documento])
);

