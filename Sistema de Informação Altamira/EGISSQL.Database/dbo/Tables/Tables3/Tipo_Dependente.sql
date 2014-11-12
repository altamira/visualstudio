CREATE TABLE [dbo].[Tipo_Dependente] (
    [cd_tipo_dependente] INT          NOT NULL,
    [nm_tipo_dependente] VARCHAR (30) NOT NULL,
    [sg_tipo_dependente] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Dependente] PRIMARY KEY CLUSTERED ([cd_tipo_dependente] ASC) WITH (FILLFACTOR = 90)
);

