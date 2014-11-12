CREATE TABLE [dbo].[Mapa_Carga_Fechamento] (
    [cd_controle]    INT      NOT NULL,
    [dt_faturamento] DATETIME NULL,
    [dt_entrega]     DATETIME NULL,
    [dt_fechamento]  DATETIME NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    [cd_ordem_carga] INT      NULL,
    CONSTRAINT [PK_Mapa_Carga_Fechamento] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90)
);

