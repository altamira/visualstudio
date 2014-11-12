CREATE TABLE [dbo].[Quinzena] (
    [cd_quinzena] INT          NOT NULL,
    [nm_quinzena] VARCHAR (40) NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Quinzena] PRIMARY KEY CLUSTERED ([cd_quinzena] ASC) WITH (FILLFACTOR = 90)
);

