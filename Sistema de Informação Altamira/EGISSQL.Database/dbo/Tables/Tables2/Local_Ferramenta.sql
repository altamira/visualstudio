CREATE TABLE [dbo].[Local_Ferramenta] (
    [cd_local_ferramenta] INT          NOT NULL,
    [nm_local_ferramenta] VARCHAR (40) NULL,
    [sg_local_ferramenta] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Local_Ferramenta] PRIMARY KEY CLUSTERED ([cd_local_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

