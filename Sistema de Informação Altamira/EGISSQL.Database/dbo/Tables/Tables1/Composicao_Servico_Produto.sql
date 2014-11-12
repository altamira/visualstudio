CREATE TABLE [dbo].[Composicao_Servico_Produto] (
    [cd_grupo_produto]      INT          NOT NULL,
    [cd_produto]            INT          NOT NULL,
    [cd_servico_terceiro]   INT          NOT NULL,
    [nm_obs_comp_serv_prod] VARCHAR (40) NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    CONSTRAINT [PK_Composicao_Servico_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_produto] ASC, [cd_servico_terceiro] ASC) WITH (FILLFACTOR = 90)
);

