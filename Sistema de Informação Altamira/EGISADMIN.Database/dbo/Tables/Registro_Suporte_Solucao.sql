CREATE TABLE [dbo].[Registro_Suporte_Solucao] (
    [cd_registro_suporte] INT      NOT NULL,
    [dt_solucao]          DATETIME NULL,
    [ds_solucao]          TEXT     NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_Registro_Suporte_Solucao] PRIMARY KEY CLUSTERED ([cd_registro_suporte] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Suporte_Solucao_Registro_Suporte] FOREIGN KEY ([cd_registro_suporte]) REFERENCES [dbo].[Registro_Suporte] ([cd_registro_suporte])
);

