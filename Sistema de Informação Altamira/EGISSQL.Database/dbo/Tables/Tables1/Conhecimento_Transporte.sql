CREATE TABLE [dbo].[Conhecimento_Transporte] (
    [cd_controle]             INT          NOT NULL,
    [dt_conhecimento]         DATETIME     NULL,
    [cd_cliente]              INT          NULL,
    [cd_consignatario]        INT          NULL,
    [cd_cliente_destinatario] INT          NULL,
    [cd_cliente_redespacho]   INT          NULL,
    [cd_veiculo]              INT          NULL,
    [cd_motorista]            INT          NULL,
    [ds_obs_frete]            TEXT         NULL,
    [nm_local_coleta]         VARCHAR (60) NULL,
    [nm_local_entrega]        VARCHAR (60) NULL,
    [cd_nota_saida]           INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_frete_consig]         CHAR (1)     NULL,
    [ic_frete_redespacho]     CHAR (1)     NULL,
    [cd_operacao_fiscal]      INT          NULL,
    [cd_conhecimento]         INT          NULL,
    [cd_condicao_pagamento]   INT          NULL,
    CONSTRAINT [PK_Conhecimento_Transporte] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90)
);

