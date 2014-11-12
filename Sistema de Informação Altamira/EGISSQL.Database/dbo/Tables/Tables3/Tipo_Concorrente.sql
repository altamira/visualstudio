CREATE TABLE [dbo].[Tipo_Concorrente] (
    [sg_tipo_concorrente] CHAR (10)    NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [cd_tipo_concorrente] INT          NOT NULL,
    [nm_tipo_concorrente] VARCHAR (30) NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Concorrente] PRIMARY KEY CLUSTERED ([cd_tipo_concorrente] ASC) WITH (FILLFACTOR = 90)
);

