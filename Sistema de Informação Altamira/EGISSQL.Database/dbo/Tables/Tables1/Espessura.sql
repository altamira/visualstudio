CREATE TABLE [dbo].[Espessura] (
    [cd_espessura]              INT          NOT NULL,
    [nm_espessura]              VARCHAR (30) NULL,
    [nm_espessura_polegada]     VARCHAR (15) NULL,
    [qt_polegada_espessura]     FLOAT (53)   NULL,
    [qt_espessura]              FLOAT (53)   NULL,
    [qt_peso_especifico]        FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_peso_especifico_espess] FLOAT (53)   NULL,
    CONSTRAINT [PK_Espessura] PRIMARY KEY CLUSTERED ([cd_espessura] ASC) WITH (FILLFACTOR = 90)
);

