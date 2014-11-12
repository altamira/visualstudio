CREATE TABLE [dbo].[Bandeira_Combustivel] (
    [cd_bandeira]          INT          NOT NULL,
    [nm_bandeira]          VARCHAR (40) NULL,
    [nm_fantasia_bandeira] VARCHAR (15) NULL,
    [sg_bandeira]          CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Bandeira_Combustivel] PRIMARY KEY CLUSTERED ([cd_bandeira] ASC)
);

