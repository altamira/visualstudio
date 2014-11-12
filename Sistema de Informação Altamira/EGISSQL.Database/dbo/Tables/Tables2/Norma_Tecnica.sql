CREATE TABLE [dbo].[Norma_Tecnica] (
    [cd_norma_tecnica]          INT           NOT NULL,
    [nm_norma_tecnica]          VARCHAR (60)  NULL,
    [nm_fantasia_norma_tecnica] VARCHAR (15)  NULL,
    [cd_identificacao]          INT           NULL,
    [ds_norma_tecnica]          TEXT          NULL,
    [nm_caminho_norma_tecnica]  VARCHAR (150) NULL,
    [ic_ativa_norma_tecnica]    CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Norma_Tecnica] PRIMARY KEY CLUSTERED ([cd_norma_tecnica] ASC) WITH (FILLFACTOR = 90)
);

