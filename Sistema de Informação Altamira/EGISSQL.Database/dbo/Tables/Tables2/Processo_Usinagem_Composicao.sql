CREATE TABLE [dbo].[Processo_Usinagem_Composicao] (
    [cd_maquina]            INT      NULL,
    [cd_magazine]           INT      NULL,
    [cd_processo_usinagem]  INT      NULL,
    [cd_placa]              INT      NULL,
    [cd_operacao_usinagem]  INT      NULL,
    [cd_sequencia_usinagem] INT      NULL,
    [cd_ordem]              INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [ic_rasgo_placa]        CHAR (1) NULL,
    CONSTRAINT [FK_Processo_Usinagem_Composicao_Magazine] FOREIGN KEY ([cd_magazine]) REFERENCES [dbo].[Magazine] ([cd_magazine]),
    CONSTRAINT [FK_Processo_Usinagem_Composicao_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Processo_Usinagem_Composicao_Operacao_Usinagem] FOREIGN KEY ([cd_operacao_usinagem]) REFERENCES [dbo].[Operacao_Usinagem] ([cd_operacao_usinagem]),
    CONSTRAINT [FK_Processo_Usinagem_Composicao_Placa] FOREIGN KEY ([cd_placa]) REFERENCES [dbo].[Placa] ([cd_placa]),
    CONSTRAINT [FK_Processo_Usinagem_Composicao_Processo_Usinagem] FOREIGN KEY ([cd_processo_usinagem]) REFERENCES [dbo].[Processo_Usinagem] ([cd_processo_usinagem]),
    CONSTRAINT [FK_Processo_Usinagem_Composicao_Sequencia_Usinagem] FOREIGN KEY ([cd_sequencia_usinagem]) REFERENCES [dbo].[Sequencia_Usinagem] ([cd_sequencia_usinagem])
);

