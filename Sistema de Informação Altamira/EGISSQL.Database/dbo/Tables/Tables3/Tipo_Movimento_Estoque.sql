CREATE TABLE [dbo].[Tipo_Movimento_Estoque] (
    [cd_tipo_movimento_estoque] INT          NOT NULL,
    [nm_tipo_movimento_estoque] VARCHAR (30) NULL,
    [sg_tipo_movimento_estoque] CHAR (10)    NULL,
    [ic_qtd_tipo_movimento]     CHAR (1)     NULL,
    [ic_consumo_tipo_movimento] CHAR (1)     NULL,
    [ic_contab_tipo_movimento]  CHAR (1)     NULL,
    [ic_mov_tipo_movimento]     CHAR (1)     NULL,
    [nm_atributo_produto_saldo] VARCHAR (30) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_operacao_movto_estoque] CHAR (1)     NULL,
    [ic_altera_lancto_movto]    CHAR (1)     NULL,
    [ic_lanc_aplicacao]         CHAR (1)     NULL,
    [ic_movimento_receita]      CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Movimento_Estoque] PRIMARY KEY CLUSTERED ([cd_tipo_movimento_estoque] ASC) WITH (FILLFACTOR = 90)
);

