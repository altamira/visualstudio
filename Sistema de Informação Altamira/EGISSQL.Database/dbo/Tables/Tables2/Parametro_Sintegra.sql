CREATE TABLE [dbo].[Parametro_Sintegra] (
    [cd_empresa]               INT      NOT NULL,
    [qt_dia_validade_consulta] INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Parametro_Sintegra] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

