CREATE TABLE [dbo].[Observacao_Documento_Fiscal] (
    [cd_observacao_fiscal] INT          NOT NULL,
    [nm_observacao_fiscal] VARCHAR (30) NULL,
    [sg_observacao_fiscal] CHAR (10)    NULL,
    [ds_observacao_fiscal] TEXT         NULL,
    [cd_documento_fiscal]  INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Observacao_Documento_Fiscal] PRIMARY KEY CLUSTERED ([cd_observacao_fiscal] ASC) WITH (FILLFACTOR = 90)
);

