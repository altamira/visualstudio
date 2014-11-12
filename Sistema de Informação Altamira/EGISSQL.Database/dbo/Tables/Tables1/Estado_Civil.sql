CREATE TABLE [dbo].[Estado_Civil] (
    [cd_estado_civil] INT          NOT NULL,
    [nm_estado_civil] VARCHAR (30) NULL,
    [sg_estado_civil] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Estado_Civil] PRIMARY KEY CLUSTERED ([cd_estado_civil] ASC) WITH (FILLFACTOR = 90)
);

