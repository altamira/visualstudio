CREATE TABLE [dbo].[Forma_Ferramenta] (
    [cd_forma_ferramenta] INT          NOT NULL,
    [nm_forma_ferramenta] VARCHAR (30) NOT NULL,
    [sg_forma_ferramenta] VARCHAR (15) NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Forma_Ferramenta] PRIMARY KEY CLUSTERED ([cd_forma_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

