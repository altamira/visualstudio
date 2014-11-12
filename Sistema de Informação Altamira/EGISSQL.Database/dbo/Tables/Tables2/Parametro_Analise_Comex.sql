CREATE TABLE [dbo].[Parametro_Analise_Comex] (
    [cd_analise_comex]       INT          NOT NULL,
    [qt_faixa_inicial]       FLOAT (53)   NULL,
    [qt_faixa_final]         FLOAT (53)   NULL,
    [nm_analise_comex]       VARCHAR (30) NULL,
    [cd_ordem_analise_comex] INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Parametro_Analise_Comex] PRIMARY KEY CLUSTERED ([cd_analise_comex] ASC) WITH (FILLFACTOR = 90)
);

