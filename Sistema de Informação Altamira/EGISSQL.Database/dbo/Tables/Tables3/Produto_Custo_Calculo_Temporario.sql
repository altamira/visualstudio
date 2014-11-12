CREATE TABLE [dbo].[Produto_Custo_Calculo_Temporario] (
    [cd_calculo_temporario] INT          NOT NULL,
    [dt_calculo_temporario] DATETIME     NULL,
    [nm_calculo_temporario] VARCHAR (50) NULL,
    [ds_calculo_temporario] TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Produto_Custo_Calculo_Temporario] PRIMARY KEY CLUSTERED ([cd_calculo_temporario] ASC) WITH (FILLFACTOR = 90)
);

