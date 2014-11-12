CREATE TABLE [dbo].[Abertura_Caixa] (
    [cd_abertura_caixa]     INT          NOT NULL,
    [dt_abertura_caixa]     DATETIME     NULL,
    [vl_abertura_caixa]     FLOAT (53)   NULL,
    [nm_obs_abertura_caixa] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [dt_ultimo_fechamento]  DATETIME     NULL,
    [vl_ultimo_fechamento]  FLOAT (53)   NULL,
    [cd_vendedor]           INT          NULL,
    [cd_loja]               INT          NULL,
    [cd_operador_caixa]     INT          NULL,
    [cd_terminal_caixa]     INT          NULL,
    CONSTRAINT [PK_Abertura_Caixa] PRIMARY KEY CLUSTERED ([cd_abertura_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Abertura_Caixa_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja]),
    CONSTRAINT [FK_Abertura_Caixa_Operador_Caixa] FOREIGN KEY ([cd_operador_caixa]) REFERENCES [dbo].[Operador_Caixa] ([cd_operador_caixa]),
    CONSTRAINT [FK_Abertura_Caixa_Terminal_Caixa] FOREIGN KEY ([cd_terminal_caixa]) REFERENCES [dbo].[Terminal_Caixa] ([cd_terminal_caixa]),
    CONSTRAINT [FK_Abertura_Caixa_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

