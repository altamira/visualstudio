CREATE TABLE [dbo].[Tipo_Tabela_Preco] (
    [cd_tipo_tabela_preco]     INT          NOT NULL,
    [nm_tipo_tabela_preco]     VARCHAR (30) COLLATE Latin1_General_CI_AS NOT NULL,
    [sg_tipo_tabela_preco]     CHAR (10)    COLLATE Latin1_General_CI_AS NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [pc_tipo_tabela_preco]     FLOAT (53)   NULL,
    [ic_pad_tipo_tabela_preco] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Tabela_Preco] PRIMARY KEY CLUSTERED ([cd_tipo_tabela_preco] ASC) WITH (FILLFACTOR = 90)
);

