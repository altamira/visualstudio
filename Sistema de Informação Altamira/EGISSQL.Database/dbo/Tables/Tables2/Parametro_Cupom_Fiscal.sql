CREATE TABLE [dbo].[Parametro_Cupom_Fiscal] (
    [cd_empresa]                INT         NOT NULL,
    [cd_indicador_1]            INT         NULL,
    [cd_indicador_2]            INT         NULL,
    [cd_indicador_3]            INT         NULL,
    [nm_porta_com]              VARCHAR (4) NULL,
    [ic_relatorio_gerencial]    CHAR (1)    NULL,
    [ic_rel_gerencial_reducaoz] CHAR (1)    NULL,
    CONSTRAINT [PK_Parametro_Cupom_Fiscal] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

