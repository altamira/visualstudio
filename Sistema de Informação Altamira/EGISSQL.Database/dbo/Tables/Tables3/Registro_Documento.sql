CREATE TABLE [dbo].[Registro_Documento] (
    [cd_documento_fiscal]       INT          NOT NULL,
    [cd_tipo_registro]          INT          NOT NULL,
    [cd_registro]               INT          NOT NULL,
    [cd_item_registro_document] INT          NOT NULL,
    [nm_registro_documento]     VARCHAR (40) NULL,
    [ic_conteudo]               CHAR (1)     NULL,
    [nm_conteudo]               VARCHAR (30) NULL,
    [nm_banco_dados]            CHAR (30)    NULL,
    [nm_stored_procedure]       VARCHAR (25) NULL,
    [nm_tabela]                 CHAR (25)    NULL,
    [nm_atributo]               CHAR (25)    NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    CONSTRAINT [PK_Registro_Documento] PRIMARY KEY NONCLUSTERED ([cd_documento_fiscal] ASC, [cd_tipo_registro] ASC, [cd_registro] ASC, [cd_item_registro_document] ASC) WITH (FILLFACTOR = 90)
);

