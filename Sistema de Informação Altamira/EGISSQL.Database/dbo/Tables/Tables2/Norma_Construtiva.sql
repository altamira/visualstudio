CREATE TABLE [dbo].[Norma_Construtiva] (
    [cd_norma_construtiva]       INT           NOT NULL,
    [nm_norma_construtiva]       VARCHAR (60)  NULL,
    [nm_fantasia_norma]          VARCHAR (15)  NULL,
    [cd_identificacao]           INT           NULL,
    [ds_norma_construtiva]       TEXT          NULL,
    [nm_caminho_norma]           VARCHAR (150) NULL,
    [ic_ativa_norma_construtiva] CHAR (1)      NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    CONSTRAINT [PK_Norma_Construtiva] PRIMARY KEY CLUSTERED ([cd_norma_construtiva] ASC) WITH (FILLFACTOR = 90)
);

