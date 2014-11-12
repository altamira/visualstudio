CREATE TABLE [dbo].[Processo_Producao_Adicao] (
    [cd_processo]        INT          NOT NULL,
    [cd_produto]         INT          NOT NULL,
    [qt_adicao]          FLOAT (53)   NULL,
    [nm_motivo_adicao]   VARCHAR (50) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [cd_produto_adicao]  INT          NOT NULL,
    [cd_fase_produto]    INT          NULL,
    [ic_estorna_estoque] CHAR (1)     NULL,
    CONSTRAINT [PK_Processo_Producao_Adicao] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_produto] ASC, [cd_produto_adicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Adicao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

