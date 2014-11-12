CREATE TABLE [dbo].[Serie_Prod_Fiscal] (
    [cd_serie_produto]          INT        NOT NULL,
    [cd_tipo_produto]           INT        NULL,
    [cd_destinacao_produto]     INT        NULL,
    [cd_procedencia_produto]    INT        NULL,
    [cd_tributacao]             INT        NULL,
    [cd_classificacao_fiscal]   INT        NULL,
    [cd_dispositivo_legal_ipi]  INT        NULL,
    [cd_dispositivo_legal_icms] INT        NULL,
    [cd_tipo_mercado]           INT        NULL,
    [cd_tipo_contabilizacao]    INT        NULL,
    [cd_lancamento_padrao]      INT        NULL,
    [pc_aliquota_icms]          FLOAT (53) NULL,
    [pc_aliquota_iss]           FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Serie_Prod_Fiscal] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC) WITH (FILLFACTOR = 90)
);

