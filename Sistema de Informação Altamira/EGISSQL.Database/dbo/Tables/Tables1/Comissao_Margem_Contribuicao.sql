CREATE TABLE [dbo].[Comissao_Margem_Contribuicao] (
    [cd_margem_contribuicao] INT        NOT NULL,
    [vl_margem_contribuicao] FLOAT (53) NULL,
    [pc_comissao]            FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    CONSTRAINT [PK_Comissao_Margem_Contribuicao] PRIMARY KEY CLUSTERED ([cd_margem_contribuicao] ASC) WITH (FILLFACTOR = 90)
);

