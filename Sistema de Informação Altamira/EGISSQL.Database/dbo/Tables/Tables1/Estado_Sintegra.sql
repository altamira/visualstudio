CREATE TABLE [dbo].[Estado_Sintegra] (
    [cd_estado]          INT      NOT NULL,
    [cd_sintegra_string] INT      NOT NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Estado_Sintegra] PRIMARY KEY CLUSTERED ([cd_estado] ASC, [cd_sintegra_string] ASC) WITH (FILLFACTOR = 90)
);

