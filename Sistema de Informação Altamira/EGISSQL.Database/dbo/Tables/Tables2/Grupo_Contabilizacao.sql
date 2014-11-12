CREATE TABLE [dbo].[Grupo_Contabilizacao] (
    [cd_grupo_produto]       INT      NOT NULL,
    [cd_tipo_mercado]        INT      NOT NULL,
    [cd_tipo_contabilizacao] INT      NOT NULL,
    [cd_lancamento_padrao]   INT      NOT NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Grupo_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_tipo_mercado] ASC) WITH (FILLFACTOR = 90)
);

