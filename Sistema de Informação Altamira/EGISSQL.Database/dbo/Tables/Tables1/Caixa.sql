CREATE TABLE [dbo].[Caixa] (
    [cd_caixa]             INT          NOT NULL,
    [nm_caixa]             VARCHAR (30) NULL,
    [nm_fantasia_caixa]    CHAR (15)    NULL,
    [qt_peso_lbs_caixa]    FLOAT (53)   NULL,
    [qt_peso_kgs_caixa]    FLOAT (53)   NULL,
    [qt_comprimento_caixa] FLOAT (53)   NULL,
    [qt_largura_caixa]     FLOAT (53)   NULL,
    [qt_altura_caixa]      FLOAT (53)   NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Caixa] PRIMARY KEY CLUSTERED ([cd_caixa] ASC) WITH (FILLFACTOR = 90)
);

