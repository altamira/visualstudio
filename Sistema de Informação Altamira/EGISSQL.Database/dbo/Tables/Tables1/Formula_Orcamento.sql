CREATE TABLE [dbo].[Formula_Orcamento] (
    [cd_formula_orcamento]   INT          NOT NULL,
    [nm_formula_orcamento]   VARCHAR (40) NULL,
    [sg_formula_orcamento]   CHAR (10)    NULL,
    [ds_formula_orcamento]   TEXT         NULL,
    [ds_parametro_orcamento] TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Formula_Orcamento] PRIMARY KEY CLUSTERED ([cd_formula_orcamento] ASC) WITH (FILLFACTOR = 90)
);

