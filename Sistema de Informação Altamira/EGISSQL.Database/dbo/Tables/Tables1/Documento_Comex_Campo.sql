CREATE TABLE [dbo].[Documento_Comex_Campo] (
    [cd_campo_documento_comex] INT          NOT NULL,
    [nm_campo_documento_comex] VARCHAR (40) NOT NULL,
    [ds_campo_documento_comex] TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Documento_Comex_Campo] PRIMARY KEY CLUSTERED ([cd_campo_documento_comex] ASC) WITH (FILLFACTOR = 90)
);

