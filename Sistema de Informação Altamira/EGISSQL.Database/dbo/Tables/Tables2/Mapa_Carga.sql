CREATE TABLE [dbo].[Mapa_Carga] (
    [cd_mapa_carga]         INT      NOT NULL,
    [cd_veiculo]            INT      NULL,
    [cd_motorista]          INT      NULL,
    [cd_nota_saida]         INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [cd_veiculo_original]   INT      NULL,
    [cd_motorista_original] INT      NULL,
    CONSTRAINT [PK_Mapa_Carga] PRIMARY KEY CLUSTERED ([cd_mapa_carga] ASC) WITH (FILLFACTOR = 90)
);

