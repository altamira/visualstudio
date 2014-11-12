CREATE TABLE [dbo].[Conhecimento_Transporte_Mercadoria] (
    [cd_controle]        INT          NOT NULL,
    [cd_item_mercadoria] INT          NOT NULL,
    [cd_natureza_carga]  INT          NULL,
    [cd_coleta]          INT          NULL,
    [cd_nota_fiscal]     INT          NULL,
    [vl_mercadoria]      FLOAT (53)   NULL,
    [qt_mercadoria]      FLOAT (53)   NULL,
    [qt_volume]          FLOAT (53)   NULL,
    [nm_especie]         VARCHAR (40) NULL,
    [nm_marca]           VARCHAR (40) NULL,
    [cd_numero]          VARCHAR (40) NULL,
    [cd_placa_veiculo]   VARCHAR (10) NULL,
    [nm_local_entrega]   VARCHAR (60) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Conhecimento_Transporte_Mercadoria] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_mercadoria] ASC) WITH (FILLFACTOR = 90)
);

