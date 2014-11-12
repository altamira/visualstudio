CREATE TABLE [dbo].[Parametro_RH] (
    [cd_empresa] INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Parametro_RH] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

