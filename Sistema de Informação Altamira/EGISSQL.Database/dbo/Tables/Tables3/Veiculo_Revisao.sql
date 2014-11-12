CREATE TABLE [dbo].[Veiculo_Revisao] (
    [cd_veiculo_revisao]     INT          NOT NULL,
    [cd_veiculo]             INT          NOT NULL,
    [dt_revisao_veiculo]     DATETIME     NOT NULL,
    [cd_tipo_revisao]        INT          NULL,
    [qt_km_revisao_veiculo]  INT          NULL,
    [nm_obs_revisao_veiculo] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_fornecedor]          INT          NULL,
    CONSTRAINT [PK_Veiculo_Revisao] PRIMARY KEY CLUSTERED ([cd_veiculo_revisao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Revisao_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]),
    CONSTRAINT [FK_Veiculo_Revisao_Tipo_Revisao_Veiculo] FOREIGN KEY ([cd_tipo_revisao]) REFERENCES [dbo].[Tipo_Revisao_Veiculo] ([cd_tipo_revisao])
);

