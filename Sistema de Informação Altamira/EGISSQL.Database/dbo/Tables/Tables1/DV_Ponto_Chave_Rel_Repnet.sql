CREATE TABLE [dbo].[DV_Ponto_Chave_Rel_Repnet] (
    [cd_diario_venda]     INT      NOT NULL,
    [cd_pontos_chave_rel] INT      NOT NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_DV_Ponto_Chave_Rel_Repnet] PRIMARY KEY CLUSTERED ([cd_diario_venda] ASC, [cd_pontos_chave_rel] ASC) WITH (FILLFACTOR = 90)
);

