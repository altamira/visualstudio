CREATE TABLE [dbo].[Maquina_Plano_Manutencao] (
    [cd_maquina]               INT           NOT NULL,
    [cd_item_plano_manutencao] INT           NOT NULL,
    [cd_operacao_manutencao]   INT           NULL,
    [cd_frequencia_manutencao] INT           NULL,
    [cd_aceitacao_manutencao]  INT           NULL,
    [nm_compl_operacao]        VARCHAR (50)  NULL,
    [nm_obs_operacao]          VARCHAR (40)  NULL,
    [nm_foto_operacao]         VARCHAR (100) NULL,
    [ds_operacao_manutencao]   TEXT          NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_seq_plano_manutencao]  INT           NULL,
    CONSTRAINT [PK_Maquina_Plano_Manutencao] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_item_plano_manutencao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Plano_Manutencao_Aceitacao_Manutencao] FOREIGN KEY ([cd_aceitacao_manutencao]) REFERENCES [dbo].[Aceitacao_Manutencao] ([cd_aceitacao_manutencao])
);

