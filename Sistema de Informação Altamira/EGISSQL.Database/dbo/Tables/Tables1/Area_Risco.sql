CREATE TABLE [dbo].[Area_Risco] (
    [cd_area_risco] INT          NOT NULL,
    [nm_area_risco] VARCHAR (30) NULL,
    [sg_area_risco] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [pk_area_risco] PRIMARY KEY CLUSTERED ([cd_area_risco] ASC) WITH (FILLFACTOR = 90)
);

