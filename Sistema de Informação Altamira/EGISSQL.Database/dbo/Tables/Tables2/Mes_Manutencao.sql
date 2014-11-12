CREATE TABLE [dbo].[Mes_Manutencao] (
    [cd_mes_manutencao] INT          NOT NULL,
    [nm_mes_manutencao] VARCHAR (15) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Mes_Manutencao] PRIMARY KEY CLUSTERED ([cd_mes_manutencao] ASC) WITH (FILLFACTOR = 90)
);

