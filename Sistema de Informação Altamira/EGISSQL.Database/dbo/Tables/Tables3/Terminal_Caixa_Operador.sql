CREATE TABLE [dbo].[Terminal_Caixa_Operador] (
    [cd_operador_terminal]        INT      NOT NULL,
    [cd_terminal_caixa]           INT      NOT NULL,
    [cd_operador_caixa]           INT      NOT NULL,
    [cd_vendedor]                 INT      NULL,
    [ic_status_terminal_operador] CHAR (1) NULL,
    [cd_usuário]                  INT      NULL,
    [dt_usuario]                  DATETIME NULL,
    [cd_veiculo]                  INT      NULL,
    CONSTRAINT [PK_Terminal_Caixa_Operador] PRIMARY KEY CLUSTERED ([cd_operador_terminal] ASC, [cd_terminal_caixa] ASC, [cd_operador_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Terminal_Caixa_Operador_Veiculo] FOREIGN KEY ([cd_veiculo]) REFERENCES [dbo].[Veiculo] ([cd_veiculo]),
    CONSTRAINT [FK_Terminal_Caixa_Operador_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

