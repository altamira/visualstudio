CREATE TABLE [dbo].[Tipo_Documento] (
    [cd_tipo_documento]         INT          NOT NULL,
    [nm_tipo_documento]         VARCHAR (30) NULL,
    [sg_tipo_documento]         CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_padrao_tipo_documento]  CHAR (1)     NULL,
    [ic_gps_tipo_documento]     CHAR (1)     NULL,
    [ic_darf_tipo_documento]    CHAR (1)     NULL,
    [ic_cob_tipo_documento]     CHAR (1)     NULL,
    [ic_imposto_tipo_documento] CHAR (1)     NULL,
    [ic_importacao_tipo_doc]    CHAR (1)     NULL,
    [ic_caixa_tipo_documento]   CHAR (1)     NULL,
    [cd_sped_fiscal]            VARCHAR (15) NULL,
    CONSTRAINT [PK_Tipo_Documento] PRIMARY KEY CLUSTERED ([cd_tipo_documento] ASC) WITH (FILLFACTOR = 90)
);

