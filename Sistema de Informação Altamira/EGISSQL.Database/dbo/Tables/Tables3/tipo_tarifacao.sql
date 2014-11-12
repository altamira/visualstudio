CREATE TABLE [dbo].[tipo_tarifacao] (
    [cd_tipo_tarifacao] INT          NOT NULL,
    [nm_tipo_tarifacao] VARCHAR (30) NOT NULL,
    [sg_tipo_tarifacao] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    CONSTRAINT [PK_tipo_tarifacao] PRIMARY KEY CLUSTERED ([cd_tipo_tarifacao] ASC) WITH (FILLFACTOR = 90)
);

