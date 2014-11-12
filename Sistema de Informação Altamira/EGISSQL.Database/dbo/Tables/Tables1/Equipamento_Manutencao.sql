CREATE TABLE [dbo].[Equipamento_Manutencao] (
    [cd_equipamento]            INT          NOT NULL,
    [dt_equipamento_manutencao] DATETIME     NOT NULL,
    [cd_tipo_manutencao]        INT          NULL,
    [cd_operador]               INT          NULL,
    [cd_fornecedor]             INT          NULL,
    [nm_obs_equip_manutencao]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Equipamento_Manutencao] PRIMARY KEY CLUSTERED ([cd_equipamento] ASC, [dt_equipamento_manutencao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Equipamento_Manutencao_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

