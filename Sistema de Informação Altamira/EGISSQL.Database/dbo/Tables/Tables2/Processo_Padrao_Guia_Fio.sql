CREATE TABLE [dbo].[Processo_Padrao_Guia_Fio] (
    [cd_processo_padrao]      INT          NOT NULL,
    [cd_item_processo_guia]   INT          NOT NULL,
    [cd_tipo_guia_fio]        INT          NULL,
    [cd_produto]              INT          NULL,
    [nm_complemento_guia_fio] VARCHAR (30) NULL,
    [nm_obs_guia_fio]         VARCHAR (40) NULL,
    [qt_produto_guia_fio]     FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_posicao_guia_fio]     VARCHAR (15) NULL,
    [nm_desenho_guia_fio]     VARCHAR (20) NULL,
    CONSTRAINT [PK_Processo_Padrao_Guia_Fio] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_item_processo_guia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Guia_Fio_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

