CREATE TABLE [dbo].[Ordem_Abastecimento] (
    [cd_ordem]              INT          NOT NULL,
    [dt_ordem]              DATETIME     NULL,
    [cd_veiculo]            INT          NULL,
    [cd_motorista]          INT          NULL,
    [cd_fornecedor]         INT          NULL,
    [cd_usuario_ordem]      INT          NULL,
    [nm_obs_ordem]          VARCHAR (40) NULL,
    [cd_tipo_combustivel]   INT          NULL,
    [qt_km_atual_ordem]     FLOAT (53)   NULL,
    [cd_nota_entrada]       INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_tipo_abastecimento] CHAR (1)     NULL,
    [qt_abastecimento]      FLOAT (53)   NULL,
    [vl_abastecimento]      FLOAT (53)   NULL,
    [qt_km_anterior_ordem]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Ordem_Abastecimento] PRIMARY KEY CLUSTERED ([cd_ordem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ordem_Abastecimento_Tipo_Combustivel] FOREIGN KEY ([cd_tipo_combustivel]) REFERENCES [dbo].[Tipo_Combustivel] ([cd_tipo_combustivel])
);

