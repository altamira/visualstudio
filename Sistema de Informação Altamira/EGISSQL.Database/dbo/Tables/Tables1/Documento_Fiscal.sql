CREATE TABLE [dbo].[Documento_Fiscal] (
    [cd_documento_fiscal]     INT           NOT NULL,
    [nm_documento_fiscal]     VARCHAR (60)  NOT NULL,
    [sg_documento_fiscal]     CHAR (10)     NOT NULL,
    [cd_modelo_documento]     VARCHAR (25)  NULL,
    [cd_usuario]              INT           NOT NULL,
    [dt_usuario]              DATETIME      NOT NULL,
    [ds_documento_fiscal]     TEXT          NULL,
    [nm_registro_sped_fiscal] VARCHAR (100) NULL,
    [cd_sped_fiscal]          VARCHAR (15)  NULL,
    CONSTRAINT [PK_Documento_Fiscal] PRIMARY KEY CLUSTERED ([cd_documento_fiscal] ASC) WITH (FILLFACTOR = 90)
);

