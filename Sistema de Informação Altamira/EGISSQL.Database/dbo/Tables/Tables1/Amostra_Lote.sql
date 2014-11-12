CREATE TABLE [dbo].[Amostra_Lote] (
    [cd_amostra_lote]     INT          NOT NULL,
    [nm_amostra_lote]     VARCHAR (60) NULL,
    [qt_inicial_lote]     FLOAT (53)   NULL,
    [qt_final_lote]       FLOAT (53)   NULL,
    [qt_amostra_lote]     FLOAT (53)   NULL,
    [nm_obs_amostra_lote] VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Amostra_Lote] PRIMARY KEY CLUSTERED ([cd_amostra_lote] ASC) WITH (FILLFACTOR = 90)
);

