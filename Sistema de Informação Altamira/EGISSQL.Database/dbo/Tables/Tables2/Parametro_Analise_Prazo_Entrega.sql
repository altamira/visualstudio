CREATE TABLE [dbo].[Parametro_Analise_Prazo_Entrega] (
    [cd_parametro_prazo] INT          NOT NULL,
    [qt_inicial_prazo]   INT          NULL,
    [qt_final_prazo]     INT          NULL,
    [nm_parametro_prazo] VARCHAR (40) NULL,
    [qt_ordem_prazo]     INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Parametro_Analise_Prazo_Entrega] PRIMARY KEY CLUSTERED ([cd_parametro_prazo] ASC) WITH (FILLFACTOR = 90)
);

