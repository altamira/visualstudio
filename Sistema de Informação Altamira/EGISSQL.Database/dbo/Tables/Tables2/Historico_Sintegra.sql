CREATE TABLE [dbo].[Historico_Sintegra] (
    [cd_historico_sintegra] INT      NOT NULL,
    [dt_historico_sintegra] DATETIME NULL,
    [cd_identificacao]      INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Historico_Sintegra] PRIMARY KEY CLUSTERED ([cd_historico_sintegra] ASC) WITH (FILLFACTOR = 90)
);

