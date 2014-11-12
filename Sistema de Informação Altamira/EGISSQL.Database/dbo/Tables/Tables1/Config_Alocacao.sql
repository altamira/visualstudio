CREATE TABLE [dbo].[Config_Alocacao] (
    [cd_empresa]              INT        NOT NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    [qt_dia_alocacao_estoque] FLOAT (53) NULL,
    CONSTRAINT [PK_Config_Alocacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_Alocacao_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

