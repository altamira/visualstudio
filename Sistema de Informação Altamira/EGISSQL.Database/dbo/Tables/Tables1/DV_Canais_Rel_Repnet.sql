CREATE TABLE [dbo].[DV_Canais_Rel_Repnet] (
    [cd_diario_venda]     INT      NOT NULL,
    [cd_canais_relatorio] INT      NOT NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_DV_Canais_Rel_Repnet] PRIMARY KEY CLUSTERED ([cd_diario_venda] ASC, [cd_canais_relatorio] ASC) WITH (FILLFACTOR = 90)
);

