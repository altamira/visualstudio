CREATE TABLE [dbo].[Salario_Familia] (
    [cd_config_mensal_folha]        INT        NOT NULL,
    [cd_classe_salario_familia]     INT        NOT NULL,
    [vl_base_salario_familia]       MONEY      NULL,
    [vl_salario_familia]            MONEY      NULL,
    [cd_usuario]                    INT        NULL,
    [dt_usuario]                    DATETIME   NULL,
    [vl_base_final_salario_familia] FLOAT (53) NULL,
    CONSTRAINT [PK_Salario_Familia] PRIMARY KEY CLUSTERED ([cd_config_mensal_folha] ASC, [cd_classe_salario_familia] ASC) WITH (FILLFACTOR = 90)
);

