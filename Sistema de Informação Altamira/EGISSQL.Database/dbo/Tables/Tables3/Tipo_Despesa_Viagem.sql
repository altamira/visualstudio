CREATE TABLE [dbo].[Tipo_Despesa_Viagem] (
    [cd_despesa_viagem]          INT          NOT NULL,
    [nm_despesa_viagem]          VARCHAR (30) NOT NULL,
    [sg_despesa_viagem]          CHAR (10)    NOT NULL,
    [cd_usuario]                 INT          NOT NULL,
    [dt_usuario]                 DATETIME     NOT NULL,
    [ic_gerar_km_final]          CHAR (1)     NULL,
    [cd_plano_financeiro]        INT          NULL,
    [ic_tipo_despesa_viagem]     CHAR (1)     NULL,
    [cd_remessa_viagem]          INT          NULL,
    [ic_valor_comercial_despesa] CHAR (1)     NULL,
    [cd_conta]                   INT          NULL,
    [ic_tipo_pagamento_despesa]  CHAR (1)     NULL,
    [ic_scp_tipo_despesa]        CHAR (1)     NULL,
    [cd_tipo_documento]          INT          NULL,
    [cd_tipo_conta_pagar]        INT          NULL,
    [ic_reembolsavel_despesa]    CHAR (1)     NULL,
    [nm_obs_tipo_despesa]        VARCHAR (40) NULL,
    [ic_comissao_motorista]      CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Despesa_Viagem] PRIMARY KEY CLUSTERED ([cd_despesa_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Despesa_Viagem_Tipo_Conta_Pagar] FOREIGN KEY ([cd_tipo_conta_pagar]) REFERENCES [dbo].[Tipo_Conta_Pagar] ([cd_tipo_conta_pagar]),
    CONSTRAINT [FK_Tipo_Despesa_Viagem_Tipo_Documento] FOREIGN KEY ([cd_tipo_documento]) REFERENCES [dbo].[Tipo_Documento] ([cd_tipo_documento])
);

