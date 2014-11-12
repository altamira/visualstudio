CREATE TABLE [dbo].[Config_Orcamento] (
    [cd_empresa]               INT      NOT NULL,
    [cd_metodo_orcamento]      INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [ic_valor_custo_orcamento] CHAR (1) NULL,
    CONSTRAINT [FK_Config_Orcamento_Metodo_Orcamento] FOREIGN KEY ([cd_metodo_orcamento]) REFERENCES [dbo].[Metodo_Orcamento] ([cd_metodo_orcamento])
);

