CREATE TABLE [dbo].[Parentesco] (
    [cd_parentesco] INT          NOT NULL,
    [nm_parentesco] VARCHAR (60) NULL,
    [sg_parentesco] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Parentesco] PRIMARY KEY CLUSTERED ([cd_parentesco] ASC) WITH (FILLFACTOR = 90)
);

