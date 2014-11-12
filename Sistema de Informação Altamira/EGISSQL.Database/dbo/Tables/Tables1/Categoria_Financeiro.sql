CREATE TABLE [dbo].[Categoria_Financeiro] (
    [cd_categoria_financeiro]     INT          NOT NULL,
    [nm_categoria_financeiro]     VARCHAR (40) NULL,
    [sg_categoria_financeiro]     CHAR (10)    NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_cpv_categoria_financeiro] CHAR (1)     NULL,
    [vl_categoria_financeiro]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Categoria_Financeiro] PRIMARY KEY CLUSTERED ([cd_categoria_financeiro] ASC) WITH (FILLFACTOR = 90)
);

