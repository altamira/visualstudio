CREATE TABLE [dbo].[Materia_Prima_Fornecedor_Historico] (
    [cd_controle]            INT        NOT NULL,
    [dt_historico_mat_prima] DATETIME   NOT NULL,
    [vl_historico_mat_prima] FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    CONSTRAINT [PK_Materia_Prima_Fornecedor_Historico] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [dt_historico_mat_prima] ASC) WITH (FILLFACTOR = 90)
);

