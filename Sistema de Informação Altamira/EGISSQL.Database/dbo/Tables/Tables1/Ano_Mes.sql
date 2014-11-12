CREATE TABLE [dbo].[Ano_Mes] (
    [cd_ano]               INT        NOT NULL,
    [cd_mes]               INT        NOT NULL,
    [qt_dia_util_ano_mes]  INT        NULL,
    [qt_dia_trans_ano_mes] INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [qt_semana_mes]        FLOAT (53) NULL,
    CONSTRAINT [PK_Ano_Mes] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_mes] ASC) WITH (FILLFACTOR = 90)
);

