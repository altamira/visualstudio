CREATE TABLE [dbo].[Consulta_Exportacao] (
    [cd_consulta] INT      NOT NULL,
    [cd_usuario]  INT      NULL,
    [dt_usuario]  DATETIME NULL,
    CONSTRAINT [PK_Consulta_Exportacao] PRIMARY KEY CLUSTERED ([cd_consulta] ASC) WITH (FILLFACTOR = 90)
);

