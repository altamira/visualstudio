CREATE TABLE [dbo].[Religiao] (
    [cd_religiao] INT          NOT NULL,
    [nm_religiao] VARCHAR (40) NULL,
    [sg_religiao] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Religiao] PRIMARY KEY CLUSTERED ([cd_religiao] ASC) WITH (FILLFACTOR = 90)
);

