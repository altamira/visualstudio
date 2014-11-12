CREATE TABLE [dbo].[Tolerancia_Produto] (
    [cd_tolerancia_produto]        INT          NOT NULL,
    [nm_tolerancia_produto]        VARCHAR (40) NULL,
    [nm_fantasia_tolerancia]       VARCHAR (15) NULL,
    [qt_inicio_tolerancia]         FLOAT (53)   NULL,
    [qt_fim_tolerancia]            FLOAT (53)   NULL,
    [ds_tolerancia_produto]        TEXT         NULL,
    [nm_obs_tolerancia_produto]    VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [qt_dimensao_inicial]          FLOAT (53)   NULL,
    [qt_dimensao_final]            FLOAT (53)   NULL,
    [ic_padrao_tolerancia_produto] CHAR (1)     NULL,
    CONSTRAINT [PK_Tolerancia_Produto] PRIMARY KEY CLUSTERED ([cd_tolerancia_produto] ASC) WITH (FILLFACTOR = 90)
);

