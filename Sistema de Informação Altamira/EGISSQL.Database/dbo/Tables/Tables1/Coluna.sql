CREATE TABLE [dbo].[Coluna] (
    [cd_produto]         INT        NOT NULL,
    [qt_diam1_coluna]    FLOAT (53) NOT NULL,
    [qt_diam2_coluna]    FLOAT (53) NULL,
    [qt_diam3_coluna]    FLOAT (53) NULL,
    [qt_comp1_coluna]    FLOAT (53) NOT NULL,
    [qt_comp2_coluna]    FLOAT (53) NULL,
    [qt_comp3_coluna]    FLOAT (53) NULL,
    [qt_comp4_coluna]    FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    [qt_diam4_coluna]    FLOAT (53) NULL,
    [qt_comp5_coluna]    FLOAT (53) NULL,
    [qt_comp6_coluna]    FLOAT (53) NULL,
    [qt_comp7_coluna]    FLOAT (53) NULL,
    [qt_comp8_coluna]    FLOAT (53) NULL,
    [qt_comp9_coluna]    FLOAT (53) NULL,
    [ic_coluna_montagem] CHAR (1)   NULL,
    CONSTRAINT [PK_Coluna] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

