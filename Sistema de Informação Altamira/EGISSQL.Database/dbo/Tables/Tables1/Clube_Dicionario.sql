CREATE TABLE [dbo].[Clube_Dicionario] (
    [cd_dicionario] INT          NOT NULL,
    [nm_dicionario] VARCHAR (60) NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Clube_Dicionario] PRIMARY KEY CLUSTERED ([cd_dicionario] ASC)
);

