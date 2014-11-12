CREATE TABLE [dbo].[Sistema] (
    [cd_sistema]      INT          NOT NULL,
    [nm_sistema]      VARCHAR (30) NOT NULL,
    [sg_sistema]      CHAR (10)    NOT NULL,
    [cd_tipo_sistema] INT          NOT NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Sistema] PRIMARY KEY NONCLUSTERED ([cd_sistema] ASC) WITH (FILLFACTOR = 90)
);

