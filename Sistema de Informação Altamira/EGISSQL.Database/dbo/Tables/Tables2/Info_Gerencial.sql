CREATE TABLE [dbo].[Info_Gerencial] (
    [cd_info_gerencial] INT          NOT NULL,
    [nm_info_gerencial] VARCHAR (40) NOT NULL,
    [sg_info_gerencial] CHAR (15)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Info_Gerencial] PRIMARY KEY CLUSTERED ([cd_info_gerencial] ASC) WITH (FILLFACTOR = 90)
);

