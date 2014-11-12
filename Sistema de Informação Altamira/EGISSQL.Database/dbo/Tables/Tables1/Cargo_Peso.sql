CREATE TABLE [dbo].[Cargo_Peso] (
    [cd_cargo_peso] INT          NOT NULL,
    [nm_cargo_peso] VARCHAR (40) NULL,
    [sg_cargo_peso] CHAR (10)    NULL,
    [qt_cargo_peso] FLOAT (53)   NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Peso] PRIMARY KEY CLUSTERED ([cd_cargo_peso] ASC) WITH (FILLFACTOR = 90)
);

