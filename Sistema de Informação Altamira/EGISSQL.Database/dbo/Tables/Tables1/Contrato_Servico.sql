﻿CREATE TABLE [dbo].[Contrato_Servico] (
    [cd_contrato_servico]       INT          NOT NULL,
    [dt_contrato_servico]       DATETIME     NULL,
    [cd_ref_contrato_servico]   VARCHAR (20) NULL,
    [cd_cliente]                INT          NULL,
    [ds_contrato]               TEXT         NULL,
    [cd_vendedor]               INT          NULL,
    [cd_condicao_pagamento]     INT          NULL,
    [dt_ini_contrato_servico]   DATETIME     NULL,
    [dt_final_contrato_servico] DATETIME     NULL,
    [qt_parc_contrato_servico]  INT          NULL,
    [dt_vct1p_contrato_servico] DATETIME     NULL,
    [qt_iparc_contrato_servico] INT          NULL,
    [cd_status_contrato]        INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_servico]                INT          NULL,
    [vl_contrato_servico]       FLOAT (53)   NULL,
    [cd_tipo_contrato]          INT          NULL,
    [cd_tipo_reajuste]          INT          NULL,
    [nm_motivo_canc_contrato]   VARCHAR (40) NULL,
    [dt_cancelamento_contrato]  DATETIME     NULL,
    [dt_base_reajuste_contrato] DATETIME     NULL,
    [cd_indice_reajuste]        INT          NULL,
    [qt_hora_contrato_servico]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Contrato_Servico] PRIMARY KEY CLUSTERED ([cd_contrato_servico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Servico_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Contrato_Servico_Condicao_Pagamento] FOREIGN KEY ([cd_condicao_pagamento]) REFERENCES [dbo].[Condicao_Pagamento] ([cd_condicao_pagamento]),
    CONSTRAINT [FK_Contrato_Servico_Indice_Reajuste] FOREIGN KEY ([cd_indice_reajuste]) REFERENCES [dbo].[Indice_Reajuste] ([cd_indice_reajuste]),
    CONSTRAINT [FK_Contrato_Servico_Status_Contrato] FOREIGN KEY ([cd_status_contrato]) REFERENCES [dbo].[Status_Contrato] ([cd_status_contrato]),
    CONSTRAINT [FK_Contrato_Servico_Tipo_Reajuste] FOREIGN KEY ([cd_tipo_reajuste]) REFERENCES [dbo].[Tipo_Reajuste] ([cd_tipo_reajuste]),
    CONSTRAINT [FK_Contrato_Servico_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

