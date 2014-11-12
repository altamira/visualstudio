CREATE TABLE [dbo].[Tipo_Produto] (
    [cd_tipo_produto]        INT          NOT NULL,
    [nm_tipo_produto]        VARCHAR (30) NULL,
    [sg_tipo_produto]        CHAR (10)    NULL,
    [cd_fiscal_tipo_produto] CHAR (5)     NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_smo_tipo_produto]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_produto] ASC) WITH (FILLFACTOR = 90)
);

