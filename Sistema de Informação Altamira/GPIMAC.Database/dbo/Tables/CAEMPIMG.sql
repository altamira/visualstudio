CREATE TABLE [dbo].[CAEMPIMG] (
    [CEmpImgCod] CHAR (2)        NOT NULL,
    [CEmpImgImg] VARBINARY (MAX) NULL,
    [CEmpImgExt] CHAR (5)        NULL,
    PRIMARY KEY CLUSTERED ([CEmpImgCod] ASC)
);

