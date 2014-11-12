CREATE TABLE [dbo].[Departamento_Plano_Compra] (
    [cd_departamento_plano] INT      NOT NULL,
    [cd_departamento]       INT      NULL,
    [cd_plano_compra]       INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Departamento_Plano_Compra] PRIMARY KEY CLUSTERED ([cd_departamento_plano] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Plano_Compra_Plano_Compra] FOREIGN KEY ([cd_plano_compra]) REFERENCES [dbo].[Plano_Compra] ([cd_plano_compra])
);

