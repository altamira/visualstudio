CREATE TABLE [dbo].[Situacao_Documento_Pagar] (
    [cd_situacao_documento]     INT          NOT NULL,
    [nm_situacao_documento]     VARCHAR (40) NULL,
    [sg_situacao_documento]     CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_pad_situacao_documento] CHAR (1)     NULL,
    [ic_situacao_documento]     CHAR (1)     NULL,
    CONSTRAINT [PK_Situacao_Documento_Pagar] PRIMARY KEY CLUSTERED ([cd_situacao_documento] ASC) WITH (FILLFACTOR = 90)
);

