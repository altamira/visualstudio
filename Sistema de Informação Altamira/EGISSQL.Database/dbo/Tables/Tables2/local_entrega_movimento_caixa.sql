CREATE TABLE [dbo].[local_entrega_movimento_caixa] (
    [cd_local_entrega_mov_caixa] INT          NOT NULL,
    [sg_local_entrega_mov_caixa] CHAR (2)     NOT NULL,
    [nm_local_entrega_mov_caixa] VARCHAR (40) NOT NULL,
    [ic_selecao_movimento_caixa] CHAR (1)     NOT NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_pad_entrega_mov_caixa]   CHAR (1)     NULL,
    CONSTRAINT [PK_local_entrega_movimento_caixa] PRIMARY KEY CLUSTERED ([cd_local_entrega_mov_caixa] ASC) WITH (FILLFACTOR = 90)
);

