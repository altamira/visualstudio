CREATE TABLE [dbo].[Cargo] (
    [cd_cargo]   INT          NOT NULL,
    [nm_cargo]   VARCHAR (30) NOT NULL,
    [sg_cargo]   CHAR (10)    NOT NULL,
    [cd_usuario] INT          NOT NULL,
    [dt_usuario] DATETIME     NOT NULL,
    [ds_cargo]   TEXT         NULL,
    CONSTRAINT [PK_Cargo] PRIMARY KEY CLUSTERED ([cd_cargo] ASC) WITH (FILLFACTOR = 90)
);

