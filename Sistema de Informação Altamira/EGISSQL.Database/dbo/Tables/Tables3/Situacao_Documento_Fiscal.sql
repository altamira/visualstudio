CREATE TABLE [dbo].[Situacao_Documento_Fiscal] (
    [cd_situacao_documento] INT           NOT NULL,
    [nm_situacao_documento] VARCHAR (100) NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [cd_sped_fiscal]        VARCHAR (15)  NULL,
    CONSTRAINT [PK_Situacao_Documento_Fiscal] PRIMARY KEY CLUSTERED ([cd_situacao_documento] ASC) WITH (FILLFACTOR = 90)
);

