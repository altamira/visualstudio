CREATE TABLE [dbo].[Tipo_Liquidacao] (
    [cd_tipo_liquidacao]          INT          NOT NULL,
    [nm_tipo_liquidacao]          VARCHAR (30) NULL,
    [sg_tipo_liquidacao]          CHAR (10)    NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_banco_tipo_liquidacao]    CHAR (1)     NULL,
    [ic_padrao_tipo_liquidacao]   CHAR (1)     NULL,
    [ic_caixa_tipo_liquidacao]    CHAR (1)     NULL,
    [ic_comissao_tipo_liquidacao] CHAR (1)     NULL,
    [cd_conta]                    INT          NULL,
    [ic_fluxo_tipo_liquidacao]    CHAR (1)     NULL,
    [ic_rel_doc_tipo_liquidacao]  CHAR (1)     NULL,
    [ic_mov_tipo_liquidacao]      CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Liquidacao] PRIMARY KEY CLUSTERED ([cd_tipo_liquidacao] ASC) WITH (FILLFACTOR = 90)
);

