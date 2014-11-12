CREATE TABLE [dbo].[Contrato_Imovel] (
    [cd_contrato_pagar]         INT           NOT NULL,
    [nm_contrato_pagar]         VARCHAR (25)  NULL,
    [cd_igreja]                 INT           NULL,
    [cd_tipo_conta_pagar]       INT           NULL,
    [dt_emissao_contrato]       DATETIME      NULL,
    [dt_recisao_contrato]       DATETIME      NULL,
    [ds_historico_contrato]     TEXT          NULL,
    [vl_total_contrato_pagar]   FLOAT (53)    NULL,
    [dt_vencimento_contrato_pa] DATETIME      NULL,
    [qt_parcela_contrato_pagar] INT           NULL,
    [dt_vcto_1p_contrato_pagar] DATETIME      NULL,
    [qt_intervalo_parcela]      INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_caminho_contrato]       VARCHAR (100) NULL,
    [cd_imovel]                 INT           NULL,
    CONSTRAINT [PK_Contrato_Imovel] PRIMARY KEY CLUSTERED ([cd_contrato_pagar] ASC) WITH (FILLFACTOR = 90)
);

