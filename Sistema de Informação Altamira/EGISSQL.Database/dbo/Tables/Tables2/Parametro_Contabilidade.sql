CREATE TABLE [dbo].[Parametro_Contabilidade] (
    [cd_empresa]                 INT        NULL,
    [ic_cfop_contab_entrada]     CHAR (1)   NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [ic_quebra_conta_balancete]  CHAR (1)   NULL,
    [cd_termo_abertura_diario]   INT        NULL,
    [cd_termo_encerram_diario]   INT        NULL,
    [cd_reduzido_final]          INT        NULL,
    [cd_reduzido_inicial]        INT        NULL,
    [qt_nivel_balancete]         FLOAT (53) NULL,
    [ic_tipo_balancete]          CHAR (1)   NULL,
    [ic_centro_custo_receita]    CHAR (1)   NULL,
    [ic_libera_reduzido_empresa] CHAR (1)   NULL,
    [ic_soma_conta_balancete]    CHAR (1)   NULL,
    CONSTRAINT [FK_Parametro_Contabilidade_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

