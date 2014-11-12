CREATE TABLE [dbo].[Indicador_Resultado] (
    [cd_indicador]        INT        NOT NULL,
    [dt_inicio_indicador] DATETIME   NOT NULL,
    [dt_final_indicador]  DATETIME   NOT NULL,
    [vl_meta_indicador]   FLOAT (53) NULL,
    [vl_indicador]        FLOAT (53) NULL,
    [qt_meta_indicador]   FLOAT (53) NULL,
    [qt_indicador]        FLOAT (53) NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [PK_Indicador_Resultado] PRIMARY KEY CLUSTERED ([cd_indicador] ASC, [dt_inicio_indicador] ASC, [dt_final_indicador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Indicador_Resultado_Indicador] FOREIGN KEY ([cd_indicador]) REFERENCES [dbo].[Indicador] ([cd_indicador])
);

