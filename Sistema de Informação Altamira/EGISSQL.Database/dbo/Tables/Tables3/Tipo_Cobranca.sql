CREATE TABLE [dbo].[Tipo_Cobranca] (
    [cd_tipo_cobranca]          INT          NOT NULL,
    [nm_tipo_cobranca]          VARCHAR (30) NULL,
    [sg_tipo_cobranca]          CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_padrao_tipo_cobranca]   CHAR (1)     NULL,
    [ic_cnab_tipo_cobranca]     CHAR (1)     NULL,
    [ic_desconto_tipo_cobranca] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Cobranca] PRIMARY KEY CLUSTERED ([cd_tipo_cobranca] ASC) WITH (FILLFACTOR = 90)
);

