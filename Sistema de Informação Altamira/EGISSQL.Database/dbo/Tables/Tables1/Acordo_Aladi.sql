CREATE TABLE [dbo].[Acordo_Aladi] (
    [cd_acordo_aladi] INT          NOT NULL,
    [nm_acordo_aladi] VARCHAR (40) NOT NULL,
    [sg_acordo_aladi] CHAR (10)    NOT NULL,
    [cd_siscomex]     INT          NOT NULL,
    [cd_ususario]     INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    [cd_usuario]      INT          NULL,
    CONSTRAINT [PK_Acordo_Aladi] PRIMARY KEY CLUSTERED ([cd_acordo_aladi] ASC) WITH (FILLFACTOR = 90)
);

