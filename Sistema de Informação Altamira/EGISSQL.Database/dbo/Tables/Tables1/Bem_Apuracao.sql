CREATE TABLE [dbo].[Bem_Apuracao] (
    [cd_bem]          INT        NOT NULL,
    [cd_parcela]      INT        NOT NULL,
    [qt_mes]          INT        NULL,
    [qt_ano]          INT        NULL,
    [vl_apuracao_bem] FLOAT (53) NULL,
    [qt_fator]        FLOAT (53) NULL,
    [cd_usuario]      INT        NULL,
    [dt_usuario]      DATETIME   NULL,
    CONSTRAINT [PK_Bem_Apuracao] PRIMARY KEY CLUSTERED ([cd_bem] ASC, [cd_parcela] ASC) WITH (FILLFACTOR = 90)
);

