﻿CREATE TABLE [dbo].[Portador] (
    [cd_portador]               INT          NOT NULL,
    [nm_portador]               VARCHAR (30) NULL,
    [sg_portador]               CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_banco]                  INT          NULL,
    [cd_documento_magnetico]    INT          NULL,
    [ic_eletronica_portador]    CHAR (1)     NULL,
    [ic_padrao_portador]        CHAR (1)     NULL,
    [ic_ctb_ret_baixa_portador] CHAR (1)     NULL,
    [ds_portador]               TEXT         NULL,
    [ic_contab_baixa_portador]  CHAR (1)     NULL,
    [ic_cob_manual_portador]    CHAR (1)     NULL,
    [ic_anuencia_portador]      CHAR (1)     NULL,
    [cd_conta_banco]            INT          NULL,
    [qt_credito_efetivo]        INT          NULL,
    [cd_plano_financeiro]       INT          NULL,
    [ic_documento_emitido]      CHAR (1)     NULL,
    [cd_tipo_cobranca]          INT          NULL,
    [cd_tipo_documento]         INT          NULL,
    [ic_fluxo_caixa_portador]   CHAR (1)     NULL,
    CONSTRAINT [PK_Portador] PRIMARY KEY CLUSTERED ([cd_portador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Portador_Tipo_Cobranca] FOREIGN KEY ([cd_tipo_cobranca]) REFERENCES [dbo].[Tipo_Cobranca] ([cd_tipo_cobranca]),
    CONSTRAINT [FK_Portador_Tipo_Documento] FOREIGN KEY ([cd_tipo_documento]) REFERENCES [dbo].[Tipo_Documento] ([cd_tipo_documento])
);

