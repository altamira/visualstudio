CREATE TABLE [dbo].[Cargo_Habilidade] (
    [cd_cargo_habilidade] INT          NOT NULL,
    [nm_cargo_habilidade] VARCHAR (60) NULL,
    [sg_cargo_habilidade] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ds_cargo_habilidade] TEXT         NULL,
    CONSTRAINT [PK_Cargo_Habilidade] PRIMARY KEY CLUSTERED ([cd_cargo_habilidade] ASC) WITH (FILLFACTOR = 90)
);

