CREATE TABLE [dbo].[Base_Estampo_Medida] (
    [cd_produto]               INT          NOT NULL,
    [qt_A1_base_estampo_medi]  INT          NULL,
    [qt_A2_base_estampo_medi]  INT          NULL,
    [qt_B1_base_estampo_medi]  INT          NULL,
    [qt_B2_base_estampo_medi]  INT          NULL,
    [qt_P1_base_estampo_medi]  INT          NULL,
    [qt_P2_base_estampo_medi]  INT          NULL,
    [qt_P3_base_estampo_medi]  INT          NULL,
    [qt_D1_base_estampo_medi]  INT          NULL,
    [qt_A2_bucha_base_estamp]  INT          NULL,
    [qt_A2_camisa_base_estamp] INT          NULL,
    [qt_B2_bucha_base_estamp]  INT          NULL,
    [qt_B2_camisa_base_estamp] FLOAT (53)   NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_sentido_alimentacao]   CHAR (1)     NULL,
    [cd_base_estampo_medida]   INT          NULL,
    [nm_fantasia_produto]      VARCHAR (30) NULL,
    CONSTRAINT [PK_Base_Estampo_Medida] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

