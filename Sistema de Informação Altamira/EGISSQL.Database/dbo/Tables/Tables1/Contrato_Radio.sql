CREATE TABLE [dbo].[Contrato_Radio] (
    [cd_contrato_radio]         INT           NOT NULL,
    [nm_contrato_radio]         VARCHAR (25)  NULL,
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
    [cd_identificao_contrato]   VARCHAR (25)  NULL,
    CONSTRAINT [PK_Contrato_Radio] PRIMARY KEY CLUSTERED ([cd_contrato_radio] ASC) WITH (FILLFACTOR = 90)
);

