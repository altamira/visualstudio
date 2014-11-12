CREATE TABLE [dbo].[Config_Resumo_Prestacao] (
    [cd_empresa]      INT      NOT NULL,
    [ic_adiantamento] CHAR (1) NULL,
    [ic_despesas]     CHAR (1) NULL,
    [ic_devolucao]    CHAR (1) NULL,
    [ic_resultado]    CHAR (1) NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    [ic_reembolso]    CHAR (1) NULL,
    CONSTRAINT [PK_Config_Resumo_Prestacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

