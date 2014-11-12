CREATE TABLE [dbo].[Origem_RNC] (
    [cd_origem_rnc] INT          NOT NULL,
    [nm_origem_rnc] VARCHAR (40) NULL,
    [sg_origem_rnc] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Origem_RNC] PRIMARY KEY CLUSTERED ([cd_origem_rnc] ASC) WITH (FILLFACTOR = 90)
);

