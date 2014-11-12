CREATE TABLE [dbo].[Prazo_Validade_Produto] (
    [cd_prazo]     INT          NOT NULL,
    [nm_prazo]     VARCHAR (40) NULL,
    [sg_prazo]     CHAR (10)    NULL,
    [qt_dia_prazo] FLOAT (53)   NULL,
    [qt_mes_prazo] FLOAT (53)   NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Prazo_Validade_Produto] PRIMARY KEY CLUSTERED ([cd_prazo] ASC) WITH (FILLFACTOR = 90)
);

