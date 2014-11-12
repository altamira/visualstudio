CREATE TABLE [dbo].[Parametro_Orcamento] (
    [cd_empresa]              INT          NOT NULL,
    [cd_grupo_orcamento]      INT          NOT NULL,
    [cd_item_parametro_orcam] INT          NOT NULL,
    [cd_orcamento_variavel]   INT          NULL,
    [nm_obs_parametro_orcam]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_categoria_orcamento]  INT          NULL,
    [vl_parametro_orcamento]  FLOAT (53)   NULL,
    [cd_variavel_orcamento]   VARCHAR (15) NULL,
    [ic_rel_proc_fabricacao]  CHAR (1)     NULL,
    CONSTRAINT [PK_Parametro_Orcamento] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_grupo_orcamento] ASC, [cd_item_parametro_orcam] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Orcamento_Orcamento_Variavel] FOREIGN KEY ([cd_orcamento_variavel]) REFERENCES [dbo].[Orcamento_Variavel] ([cd_orcamento_variavel])
);

