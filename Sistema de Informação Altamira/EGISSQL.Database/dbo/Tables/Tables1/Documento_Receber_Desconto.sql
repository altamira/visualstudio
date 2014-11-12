CREATE TABLE [dbo].[Documento_Receber_Desconto] (
    [cd_documento_receber]  INT          NOT NULL,
    [cd_item_desconto]      INT          NOT NULL,
    [dt_desconto_documento] DATETIME     NULL,
    [cd_banco]              INT          NULL,
    [vl_desconto_documento] FLOAT (53)   NULL,
    [pc_desconto_documento] FLOAT (53)   NULL,
    [nm_obs_desconto]       VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [vl_liquido_documento]  FLOAT (53)   NULL,
    [cd_plano_financeiro]   INT          NULL,
    [cd_conta_banco]        INT          NULL,
    [cd_lancamento]         INT          NULL,
    [vl_juros_desconto]     FLOAT (53)   NULL,
    [vl_iof_desconto]       FLOAT (53)   NULL,
    [vl_custo_desconto]     FLOAT (53)   NULL,
    [qt_dia_desconto]       FLOAT (53)   NULL,
    [cd_bordero_desconto]   INT          NULL,
    CONSTRAINT [PK_Documento_Receber_Desconto] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC, [cd_item_desconto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Receber_Desconto_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Documento_Receber_Desconto_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber]) ON DELETE CASCADE ON UPDATE CASCADE
);

