CREATE TABLE [dbo].[Cargo_Empresa] (
    [cd_cargo_empresa] INT          NOT NULL,
    [nm_cargo_empresa] VARCHAR (40) NOT NULL,
    [sg_cargo_empresa] CHAR (10)    NULL,
    [ds_cargo_empresa] TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Empresa] PRIMARY KEY CLUSTERED ([cd_cargo_empresa] ASC) WITH (FILLFACTOR = 90)
);

