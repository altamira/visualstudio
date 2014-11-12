CREATE TABLE [dbo].[Tipo_Conta_Pagar] (
    [cd_tipo_conta_pagar]       INT          NOT NULL,
    [nm_tipo_conta_pagar]       VARCHAR (30) NOT NULL,
    [sg_tipo_conta_pagar]       CHAR (10)    NOT NULL,
    [ic_tipo_bordero]           CHAR (1)     NOT NULL,
    [ic_razao_contabil]         CHAR (1)     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_plano_financeiro]       INT          NULL,
    [cd_tipo_pagto_eletronico]  INT          NULL,
    [cd_forma_pagto_eletronica] INT          NULL,
    [ic_importacao_tipo_conta]  CHAR (1)     NULL,
    [cd_tipo_documento]         INT          NULL,
    CONSTRAINT [PK_Tipo_Conta_pagar] PRIMARY KEY CLUSTERED ([cd_tipo_conta_pagar] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Conta_Pagar_Tipo_Documento] FOREIGN KEY ([cd_tipo_documento]) REFERENCES [dbo].[Tipo_Documento] ([cd_tipo_documento])
);

