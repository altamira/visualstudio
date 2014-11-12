CREATE TABLE [dbo].[Nota_Saida_Endereco_Entrega] (
    [cd_nota_saida]             INT          NOT NULL,
    [cd_identifica_cep]         INT          NOT NULL,
    [nm_lc_entrega_nota_saida]  VARCHAR (50) NULL,
    [nm_end_entrega_nota_saida] VARCHAR (50) NULL,
    [nm_compl_nota_saida]       VARCHAR (30) NULL,
    [nm_bairro_nota_saida]      VARCHAR (25) NULL,
    [cd_ddd_nota_saida]         CHAR (4)     NULL,
    [cd_fone_nota_saida]        VARCHAR (15) NULL,
    [cd_cidade]                 INT          NULL,
    [cd_estado]                 INT          NULL,
    [cd_pais]                   INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL
);

