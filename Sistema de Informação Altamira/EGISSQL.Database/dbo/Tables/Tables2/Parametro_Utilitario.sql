CREATE TABLE [dbo].[Parametro_Utilitario] (
    [cd_empresa] INT      NOT NULL,
    [cd_usuario] INT      NOT NULL,
    [dt_usuario] DATETIME NOT NULL,
    CONSTRAINT [PK_Parametro_Utilitario] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

