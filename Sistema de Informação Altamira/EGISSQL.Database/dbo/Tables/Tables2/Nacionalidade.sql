CREATE TABLE [dbo].[Nacionalidade] (
    [cd_nacionalidade]         INT          NOT NULL,
    [nm_nacionalidade]         VARCHAR (20) NULL,
    [sg_nacionalidade]         CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_natural_nacionalidade] VARCHAR (20) NULL,
    CONSTRAINT [PK_Nacionalidade] PRIMARY KEY CLUSTERED ([cd_nacionalidade] ASC) WITH (FILLFACTOR = 90)
);

