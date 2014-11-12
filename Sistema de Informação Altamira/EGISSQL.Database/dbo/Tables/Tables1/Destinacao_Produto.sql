CREATE TABLE [dbo].[Destinacao_Produto] (
    [cd_destinacao_produto]       INT          NOT NULL,
    [nm_destinacao_produto]       VARCHAR (30) NULL,
    [sg_destinacao_produto]       CHAR (10)    NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_pad_destinacao_produto]   CHAR (1)     NULL,
    [cd_tributacao]               INT          NULL,
    [ic_st_destinacao_produto]    CHAR (1)     NULL,
    [ic_compra_destinacao_prod]   CHAR (1)     NULL,
    [cd_grupo_produto]            INT          NULL,
    [cd_tipo_produto]             INT          NULL,
    [ic_ipi_base_icm_dest_prod]   CHAR (1)     NULL,
    [ic_fisica_destinacao_prod]   CHAR (1)     NULL,
    [ic_isento_ipi_nacional]      CHAR (1)     NULL,
    [ic_mp_aplicacada_destinacao] CHAR (1)     NULL,
    [ic_iva_st_destinacao]        CHAR (1)     NULL,
    CONSTRAINT [PK_Destinacao_Produto] PRIMARY KEY CLUSTERED ([cd_destinacao_produto] ASC) WITH (FILLFACTOR = 90)
);

