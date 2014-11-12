CREATE TABLE [dbo].[Comissao_Frete] (
    [cd_comissao_frete]           INT        NOT NULL,
    [cd_identificacao_nota_saida] INT        NULL,
    [vl_frete_nota_comissao]      FLOAT (53) NULL,
    [cd_usuario]                  INT        NULL,
    [dt_usuario]                  DATETIME   NULL,
    CONSTRAINT [PK_Comissao_Frete] PRIMARY KEY CLUSTERED ([cd_comissao_frete] ASC)
);

