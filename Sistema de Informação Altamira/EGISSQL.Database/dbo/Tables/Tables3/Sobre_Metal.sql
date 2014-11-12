CREATE TABLE [dbo].[Sobre_Metal] (
    [cd_placa]          INT        NOT NULL,
    [cd_mat_prima]      INT        NOT NULL,
    [qt_sm_espessura]   FLOAT (53) NULL,
    [qt_sm_largura]     FLOAT (53) NULL,
    [qt_sm_comprimento] FLOAT (53) NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    CONSTRAINT [PK_Sobre_Metal] PRIMARY KEY CLUSTERED ([cd_placa] ASC, [cd_mat_prima] ASC) WITH (FILLFACTOR = 90)
);

