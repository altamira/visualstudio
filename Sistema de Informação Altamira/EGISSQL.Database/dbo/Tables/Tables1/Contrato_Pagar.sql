CREATE TABLE [dbo].[Contrato_Pagar] (
    [cd_contrato_pagar]         INT           NOT NULL,
    [cd_tipo_conta_pagar]       INT           NOT NULL,
    [cd_fornecedor]             INT           NOT NULL,
    [qt_intervalo_parcela]      INT           NOT NULL,
    [dt_vcto_1p_contrato_pagar] DATETIME      NOT NULL,
    [qt_parcela_contrato_pagar] INT           NOT NULL,
    [dt_vencimento_contrato_pa] DATETIME      NOT NULL,
    [vl_total_contrato_pagar]   FLOAT (53)    NOT NULL,
    [nm_contrato_pagar]         VARCHAR (25)  NOT NULL,
    [dt_emissao_contrato]       DATETIME      NOT NULL,
    [dt_recisao_contrato]       DATETIME      NOT NULL,
    [ds_historico_contrato]     TEXT          NOT NULL,
    [cd_usuario]                INT           NOT NULL,
    [dt_usuario]                DATETIME      NOT NULL,
    [nm_fantasia_fornecedor]    CHAR (15)     NULL,
    [nm_caminho_contrato]       VARCHAR (100) NULL,
    CONSTRAINT [PK_Contrato_Pagar] PRIMARY KEY CLUSTERED ([cd_contrato_pagar] ASC) WITH (FILLFACTOR = 90)
);

