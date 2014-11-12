CREATE TABLE [dbo].[DV_Distribuicao_Diario] (
    [cd_diario_venda]        INT      NOT NULL,
    [cd_distribuicao_diario] INT      NOT NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_DV_Distribuicao_Diario] PRIMARY KEY CLUSTERED ([cd_diario_venda] ASC, [cd_distribuicao_diario] ASC) WITH (FILLFACTOR = 90)
);

