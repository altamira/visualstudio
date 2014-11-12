CREATE TABLE [dbo].[Lei_Governamental] (
    [cd_lei_governamental] INT       NOT NULL,
    [ds_governing_law]     TEXT      NULL,
    [cd_usuario]           INT       NULL,
    [dt_usuario]           DATETIME  NULL,
    [sg_lei_governamental] CHAR (10) NULL,
    CONSTRAINT [PK_Lei_Governamental] PRIMARY KEY CLUSTERED ([cd_lei_governamental] ASC) WITH (FILLFACTOR = 90)
);

