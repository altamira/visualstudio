CREATE TABLE [dbo].[Bucha] (
    [cd_produto]     INT        NOT NULL,
    [qt_diam1_bucha] FLOAT (53) NOT NULL,
    [qt_diam2_bucha] FLOAT (53) NULL,
    [qt_diam3_bucha] FLOAT (53) NULL,
    [qt_diam4_bucha] FLOAT (53) NULL,
    [qt_comp1_bucha] FLOAT (53) NOT NULL,
    [qt_comp2_bucha] FLOAT (53) NULL,
    [qt_comp3_bucha] FLOAT (53) NULL,
    [qt_comp4_bucha] FLOAT (53) NULL,
    [cd_usuario]     INT        NULL,
    [dt_usuario]     DATETIME   NULL,
    CONSTRAINT [PK_Bucha] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

