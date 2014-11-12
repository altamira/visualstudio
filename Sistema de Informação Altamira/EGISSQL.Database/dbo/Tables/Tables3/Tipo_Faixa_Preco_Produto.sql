CREATE TABLE [dbo].[Tipo_Faixa_Preco_Produto] (
    [cd_tipo_faixa_preco]     INT          NOT NULL,
    [nm_tipo_faixa_preco]     VARCHAR (40) NULL,
    [sg_tipo_faixa_preco]     CHAR (10)    NULL,
    [ic_pad_tipo_faixa_preco] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Faixa_Preco_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_faixa_preco] ASC) WITH (FILLFACTOR = 90)
);

