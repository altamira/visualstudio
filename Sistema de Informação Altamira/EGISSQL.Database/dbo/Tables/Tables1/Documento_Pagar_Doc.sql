CREATE TABLE [dbo].[Documento_Pagar_Doc] (
    [cd_documento_pagar_doc] INT           NOT NULL,
    [cd_documento_pagar]     INT           NOT NULL,
    [nm_documento_pagar_doc] VARCHAR (40)  NULL,
    [nm_caminho_documento]   VARCHAR (200) NULL,
    [ds_documento_pagar_doc] TEXT          NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Documento_Pagar_Doc] PRIMARY KEY CLUSTERED ([cd_documento_pagar_doc] ASC, [cd_documento_pagar] ASC) WITH (FILLFACTOR = 90)
);

