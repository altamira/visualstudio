CREATE TABLE [dbo].[Parametro_Conceito_Credito] (
    [cd_empresa]            INT      NOT NULL,
    [cd_item_credito]       INT      NOT NULL,
    [qt_dia_inicial_atraso] INT      NULL,
    [qt_dia_final_atraso]   INT      NULL,
    [cd_conceito_credito]   INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Parametro_Conceito_Credito] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_item_credito] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Conceito_Credito_Conceito_Credito] FOREIGN KEY ([cd_conceito_credito]) REFERENCES [dbo].[Conceito_Credito] ([cd_conceito_credito])
);

