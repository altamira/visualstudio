CREATE TABLE [dbo].[Produto_Cilindro] (
    [cd_produto]           INT          NOT NULL,
    [dt_fabricacao]        DATETIME     NULL,
    [dt_vida_util]         DATETIME     NULL,
    [dt_ultimo_teste]      DATETIME     NULL,
    [dt_ultima_lavagem]    DATETIME     NULL,
    [dt_ultima_pintura]    DATETIME     NULL,
    [dt_ultima_valvula]    DATETIME     NULL,
    [cd_contrato_locacao]  INT          NULL,
    [nm_responsavel_teste] VARCHAR (30) NULL,
    [cd_usuario_baixa]     INT          NULL,
    [dt_baixa]             DATETIME     NULL,
    [ds_observacao]        TEXT         NULL,
    [cd_estado_uso]        INT          NULL,
    [qt_produto_embalagem] FLOAT (53)   NULL,
    CONSTRAINT [PK_Produto_Cilindro] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

