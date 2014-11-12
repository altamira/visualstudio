CREATE TABLE [dbo].[Ocorrencia_Comissao] (
    [cd_ocorrencia_comissao]    INT          NOT NULL,
    [nm_ocorrencia_comissao]    VARCHAR (50) NULL,
    [ic_tipo_oper_ocorrencia]   CHAR (1)     NULL,
    [ic_subtotal_ocorrencia]    CHAR (1)     NULL,
    [ic_edita_usu_ocorrencia]   CHAR (1)     NULL,
    [ic_altera_desc_ocorrencia] CHAR (1)     NULL,
    [ic_despesa_ocorrencia]     CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_ordem_ocorrencia]       INT          NULL,
    [cd_imposto]                INT          NULL,
    [ic_rateio_comissao]        CHAR (1)     NULL,
    [ic_piso_comissao]          CHAR (1)     NULL,
    [ic_teto_comissao]          CHAR (1)     NULL,
    CONSTRAINT [PK_Ocorrencia_Comissao] PRIMARY KEY CLUSTERED ([cd_ocorrencia_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ocorrencia_Comissao_Imposto] FOREIGN KEY ([cd_imposto]) REFERENCES [dbo].[Imposto] ([cd_imposto])
);

