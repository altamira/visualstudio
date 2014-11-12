CREATE TABLE [dbo].[Item_Mes_Manutencao] (
    [cd_contrato_concessao] INT      NOT NULL,
    [cd_mes_manutencao]     INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Item_Mes_Manutencao] PRIMARY KEY CLUSTERED ([cd_contrato_concessao] ASC, [cd_mes_manutencao] ASC) WITH (FILLFACTOR = 90)
);

