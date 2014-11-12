CREATE TABLE [dbo].[origem_produto] (
    [cd_origem_produto] INT          NOT NULL,
    [nm_origem_produto] VARCHAR (40) NOT NULL,
    [sg_origem_produto] CHAR (15)    NOT NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL
);

