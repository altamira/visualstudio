CREATE TABLE [dbo].[Advogado_Natureza] (
    [cd_advogado]               INT      NOT NULL,
    [cd_natureza_processo]      INT      NOT NULL,
    [cd_tipo_processo_juridico] INT      NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Advogado_Natureza] PRIMARY KEY CLUSTERED ([cd_advogado] ASC, [cd_natureza_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Advogado_Natureza_Tipo_Processo_Juridico] FOREIGN KEY ([cd_tipo_processo_juridico]) REFERENCES [dbo].[Tipo_Processo_Juridico] ([cd_tipo_processo_juridico])
);

