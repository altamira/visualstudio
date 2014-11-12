CREATE TABLE [dbo].[Produto_Kogo] (
    [cd_produto]                INT          NOT NULL,
    [ic_consumo_produto_kogo]   CHAR (1)     NULL,
    [qt_qtypac_produto_kogo]    INT          NULL,
    [nm_newpart_produto_kogo]   VARCHAR (15) NULL,
    [nm_reason_27_produto_kogo] VARCHAR (15) NULL,
    [nm_reason_28_produto_kogo] VARCHAR (15) NULL,
    [nm_reason_29_produto_kogo] VARCHAR (15) NULL,
    [nm_reason_30_produto_kogo] VARCHAR (15) NULL,
    [nm_reason_31_produto_kogo] VARCHAR (15) NULL,
    [qt_qtybin_produto_kogo]    INT          NULL,
    [qt_bin_produto_kogo]       INT          NULL,
    [qt_stokemax_produto_kogo]  INT          NULL,
    [qt_levelmo_produto_kogo]   INT          NULL,
    [qt_dif_produto_kogo]       INT          NULL,
    [qt_mo_produto_kogo]        INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_mo_estoque_produto_kog] INT          NULL,
    CONSTRAINT [PK_Produto_Kogo] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

