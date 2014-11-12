CREATE TABLE [dbo].[Operacao_Cambio_Contrato] (
    [cd_operacao_cambio]         INT          NOT NULL,
    [cd_contrato_cambio]         INT          NOT NULL,
    [vl_vinculacao_contrato]     FLOAT (53)   NULL,
    [dt_vinculacao_contrato]     DATETIME     NULL,
    [vl_paridade_contrato]       FLOAT (53)   NULL,
    [dt_contabilizacao_contrato] DATETIME     NULL,
    [nm_obs_vinculacao_contrato] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Cambio_Contrato] PRIMARY KEY CLUSTERED ([cd_operacao_cambio] ASC, [cd_contrato_cambio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Cambio_Contrato_Contrato_Cambio] FOREIGN KEY ([cd_contrato_cambio]) REFERENCES [dbo].[Contrato_Cambio] ([cd_contrato_cambio])
);

