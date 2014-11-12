CREATE TABLE [dbo].[Parametro_Tributacao_Entrada] (
    [cd_tributacao]         INT          NOT NULL,
    [pc_reducao_ipi]        FLOAT (53)   NULL,
    [pc_reducao_icms]       FLOAT (53)   NULL,
    [nm_obs_livro_entrada]  VARCHAR (15) NULL,
    [pc_reducao_bc_ipi]     FLOAT (53)   NULL,
    [pc_reducao_bc_icms]    FLOAT (53)   NULL,
    [ic_ipi_bc_icms]        CHAR (1)     NULL,
    [ic_despesa_frete_icms] CHAR (1)     NULL,
    CONSTRAINT [PK_Parametro_Tributacao_Entrada] PRIMARY KEY CLUSTERED ([cd_tributacao] ASC) WITH (FILLFACTOR = 90)
);

