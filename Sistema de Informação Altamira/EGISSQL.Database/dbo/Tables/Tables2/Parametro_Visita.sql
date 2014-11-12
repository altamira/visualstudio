CREATE TABLE [dbo].[Parametro_Visita] (
    [cd_empresa]             INT      NOT NULL,
    [qt_dia_visita_comissao] INT      NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Parametro_Visita] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

