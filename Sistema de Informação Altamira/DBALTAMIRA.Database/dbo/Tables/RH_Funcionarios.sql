CREATE TABLE [dbo].[RH_Funcionarios] (
    [fu_Chapa]           NVARCHAR (14)  NOT NULL,
    [fu_Nome]            NVARCHAR (30)  NULL,
    [fu_Admissao]        SMALLDATETIME  NULL,
    [fu_Salario]         MONEY          NULL,
    [fu_QtdeTransporte]  INT            NULL,
    [fu_Refeicao]        INT            NULL,
    [fu_Cargo]           NVARCHAR (50)  NULL,
    [fu_Demissao]        SMALLDATETIME  NULL,
    [fu_Empresa]         INT            NOT NULL,
    [fu_DiasTrabalhados] NVARCHAR (255) NULL,
    [fu_SalarioBase]     MONEY          NULL,
    CONSTRAINT [PK_RH_Funcionarios] PRIMARY KEY NONCLUSTERED ([fu_Chapa] ASC, [fu_Empresa] ASC) WITH (FILLFACTOR = 90)
);

