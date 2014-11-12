CREATE TABLE [dbo].[Fornecedor_Sintegra] (
    [cd_fornecedor]              INT          NOT NULL,
    [dt_fornecedor_sintegra]     DATETIME     NOT NULL,
    [cd_status_retorno]          INT          NULL,
    [nm_obs_fornecedor_sintegra] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Sintegra] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [dt_fornecedor_sintegra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Sintegra_Sintegra_Status_Retorno] FOREIGN KEY ([cd_status_retorno]) REFERENCES [dbo].[Sintegra_Status_Retorno] ([cd_status_retorno])
);

