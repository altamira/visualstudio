CREATE TABLE [dbo].[Produto_Dominio] (
    [cd_produto]             INT          NOT NULL,
    [qt_inicio_dominio]      FLOAT (53)   NULL,
    [qt_final_dominio]       FLOAT (53)   NULL,
    [vl_inicio_dominio]      FLOAT (53)   NULL,
    [vl_final_dominio]       FLOAT (53)   NULL,
    [nm_obs_produto_dominio] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Produto_Dominio] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

