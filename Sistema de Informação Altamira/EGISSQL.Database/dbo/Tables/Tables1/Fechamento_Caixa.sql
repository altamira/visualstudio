CREATE TABLE [dbo].[Fechamento_Caixa] (
    [cd_fechamento_caixa]      INT          NOT NULL,
    [dt_fechamento_caixa]      DATETIME     NULL,
    [vl_fechamento_caixa]      MONEY        NULL,
    [vl_real_fechamento_caixa] MONEY        NULL,
    [nm_obs_fechamento_caixa]  VARCHAR (40) NULL,
    [ds_fechamento_caixa]      TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_vendedor]              INT          NULL,
    [cd_loja]                  INT          NULL,
    [cd_terminal_caixa]        INT          NULL,
    [cd_operador_caixa]        INT          NULL,
    CONSTRAINT [PK_Fechamento_Caixa] PRIMARY KEY CLUSTERED ([cd_fechamento_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fechamento_Caixa_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja]),
    CONSTRAINT [FK_Fechamento_Caixa_Operador_Caixa] FOREIGN KEY ([cd_operador_caixa]) REFERENCES [dbo].[Operador_Caixa] ([cd_operador_caixa]),
    CONSTRAINT [FK_Fechamento_Caixa_Terminal_Caixa] FOREIGN KEY ([cd_terminal_caixa]) REFERENCES [dbo].[Terminal_Caixa] ([cd_terminal_caixa]),
    CONSTRAINT [FK_Fechamento_Caixa_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

