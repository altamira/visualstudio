CREATE TABLE [dbo].[Operacao_Manutencao] (
    [cd_operacao_manutencao]     INT          NOT NULL,
    [nm_operacao_manutencao]     VARCHAR (60) NULL,
    [nm_fantasia_operacao]       VARCHAR (20) NULL,
    [cd_tipo_operacao_maquina]   INT          NULL,
    [cd_tipo_manutencao_maquina] INT          NULL,
    [ds_operacao_manutencao]     TEXT         NULL,
    [nm_obs_operacao_manutencao] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Manutencao] PRIMARY KEY CLUSTERED ([cd_operacao_manutencao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Manutencao_Tipo_Manutencao_Maquina] FOREIGN KEY ([cd_tipo_manutencao_maquina]) REFERENCES [dbo].[Tipo_Manutencao_Maquina] ([cd_tipo_manutencao_maq])
);

