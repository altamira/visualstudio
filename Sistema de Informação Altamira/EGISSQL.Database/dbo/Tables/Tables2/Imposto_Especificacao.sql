CREATE TABLE [dbo].[Imposto_Especificacao] (
    [cd_imposto]               INT           NOT NULL,
    [cd_imposto_especificacao] INT           NOT NULL,
    [sg_imposto_especificacao] CHAR (10)     NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [nm_imposto_especificacao] VARCHAR (120) NULL,
    CONSTRAINT [PK_Imposto_Especificacao] PRIMARY KEY CLUSTERED ([cd_imposto] ASC, [cd_imposto_especificacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Imposto_Especificacao_Imposto] FOREIGN KEY ([cd_imposto]) REFERENCES [dbo].[Imposto] ([cd_imposto])
);

