CREATE TABLE [dbo].[Canais_Relatorio_Repnet] (
    [cd_canais_relatorio] INT          NOT NULL,
    [sg_canais_relatorio] VARCHAR (25) NULL,
    [nm_canais_relatorio] VARCHAR (30) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Canais_Relatorio_Repnet] PRIMARY KEY CLUSTERED ([cd_canais_relatorio] ASC) WITH (FILLFACTOR = 90)
);

