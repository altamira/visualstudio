CREATE TABLE [dbo].[Largura_Comprimento] (
    [cd_largura_comprimento]  INT          NOT NULL,
    [nm_largura_comprimento]  VARCHAR (30) NULL,
    [qt_largura]              FLOAT (53)   NULL,
    [qt_comprimento]          FLOAT (53)   NULL,
    [nm_obs_larg_comprimento] VARCHAR (30) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Largura_Comprimento] PRIMARY KEY CLUSTERED ([cd_largura_comprimento] ASC) WITH (FILLFACTOR = 90)
);

