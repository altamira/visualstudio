CREATE TABLE [dbo].[Ciente_Prospeccao_Historico] (
    [cd_cliente_prospeccao]   INT          NOT NULL,
    [cd_sequecia_historico]   INT          NOT NULL,
    [dt_historico_lancamento] DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_historico_lancamento] TEXT         NULL,
    [nm_assunto]              VARCHAR (50) NULL,
    [cd_cliente_fase]         INT          NULL,
    [cd_vendedor]             INT          NULL,
    [cd_contato]              INT          NULL,
    [cd_cliente_assunto]      INT          NULL,
    [cd_concorrente]          INT          NULL,
    [dt_historico_retorno]    DATETIME     NULL,
    [dt_real_retorno]         DATETIME     NULL,
    CONSTRAINT [PK_Ciente_Prospeccao_Historico] PRIMARY KEY CLUSTERED ([cd_cliente_prospeccao] ASC, [cd_sequecia_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ciente_Prospeccao_Historico_Cliente_Prospeccao] FOREIGN KEY ([cd_cliente_prospeccao]) REFERENCES [dbo].[Cliente_Prospeccao] ([cd_cliente_prospeccao])
);

