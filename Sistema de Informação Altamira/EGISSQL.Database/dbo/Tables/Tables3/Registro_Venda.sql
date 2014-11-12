CREATE TABLE [dbo].[Registro_Venda] (
    [cd_registro_venda] INT      NOT NULL,
    [dt_registro_venda] DATETIME NULL,
    [cd_controle_venda] INT      NOT NULL,
    [cd_vendedor]       INT      NULL,
    [cd_operador_caixa] INT      NULL,
    [cd_loja]           INT      NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    [cd_terminal_caixa] INT      NULL,
    [cd_cliente]        INT      NULL,
    CONSTRAINT [PK_Registro_Venda] PRIMARY KEY CLUSTERED ([cd_registro_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Venda_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja]),
    CONSTRAINT [FK_Registro_Venda_Terminal_Caixa] FOREIGN KEY ([cd_terminal_caixa]) REFERENCES [dbo].[Terminal_Caixa] ([cd_terminal_caixa])
);

