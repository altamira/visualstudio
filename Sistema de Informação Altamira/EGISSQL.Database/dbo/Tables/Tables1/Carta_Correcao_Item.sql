CREATE TABLE [dbo].[Carta_Correcao_Item] (
    [cd_carta_correcao]         INT          NOT NULL,
    [cd_item_carta_correcao]    INT          NOT NULL,
    [vl_icms_carta_correcao]    FLOAT (53)   NULL,
    [vl_ipi_carta_correcao]     FLOAT (53)   NULL,
    [vl_iss_carta_correcao]     FLOAT (53)   NULL,
    [nm_informacao_correta]     VARCHAR (50) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_irregularidade_fiscal]  INT          NULL,
    [cd_tipo_irregularidade_fi] INT          NULL,
    CONSTRAINT [PK_Carta_Correcao_Item] PRIMARY KEY CLUSTERED ([cd_carta_correcao] ASC, [cd_item_carta_correcao] ASC) WITH (FILLFACTOR = 90)
);

