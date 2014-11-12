CREATE TABLE [dbo].[Calculo_Custo_Financeiro] (
    [cd_calculo_custo_fin] INT          NOT NULL,
    [nm_calculo_custo_fin] VARCHAR (40) NOT NULL,
    [ic_tipo]              CHAR (5)     NOT NULL,
    CONSTRAINT [PK_Calculo_Custo_Financeiro] PRIMARY KEY CLUSTERED ([cd_calculo_custo_fin] ASC) WITH (FILLFACTOR = 90)
);

