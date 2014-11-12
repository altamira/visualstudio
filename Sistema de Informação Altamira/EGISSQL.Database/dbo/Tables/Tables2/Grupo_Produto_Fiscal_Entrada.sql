CREATE TABLE [dbo].[Grupo_Produto_Fiscal_Entrada] (
    [cd_grupo_produto]          INT          NOT NULL,
    [cd_classificacao_fiscal]   INT          NULL,
    [cd_procedencia_produto]    INT          NULL,
    [cd_tipo_produto]           INT          NULL,
    [cd_tributacao]             INT          NULL,
    [cd_destinacao_produto]     INT          NULL,
    [pc_aliquota_iss]           FLOAT (53)   NULL,
    [pc_aliquota_icms]          FLOAT (53)   NULL,
    [ic_substrib_grupo_produto] CHAR (1)     NULL,
    [ic_isento_icms_grupo_prod] CHAR (1)     NULL,
    [nm_conta_liv_ent_grupo]    VARCHAR (10) NULL,
    [pc_interna_icms_grupo]     FLOAT (53)   NULL,
    [cd_iss_grupo_produto]      INT          NULL,
    [cd_dispositivo_legal_icms] INT          NULL,
    [cd_dispositivo_legal_ipi]  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_tipo_item]              INT          NULL,
    CONSTRAINT [PK_Grupo_Produto_Fiscal_Entrada] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90)
);

