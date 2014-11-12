CREATE TABLE [dbo].[campo_nota_fiscal] (
    [cd_campo_nota_fiscal]      INT          NOT NULL,
    [nm_campo_nota_fiscal]      VARCHAR (50) NULL,
    [ds_campo_nota_fiscal]      TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_fixo_campo_nota_fiscal] CHAR (1)     NULL,
    [qt_lin_campo_nota_fiscal]  INT          NULL,
    [qt_col_campo_nota_fiscal]  FLOAT (53)   NULL,
    [nm_campo_procedimento]     VARCHAR (60) NULL,
    CONSTRAINT [PK_campo_nota_fiscal] PRIMARY KEY CLUSTERED ([cd_campo_nota_fiscal] ASC) WITH (FILLFACTOR = 90)
);

