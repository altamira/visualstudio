CREATE TABLE [dbo].[Programador_CNC] (
    [cd_programador_cnc] INT          NOT NULL,
    [nm_programador_cnc] VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Programador_CNC] PRIMARY KEY CLUSTERED ([cd_programador_cnc] ASC) WITH (FILLFACTOR = 90)
);

