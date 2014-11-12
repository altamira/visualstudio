CREATE TABLE [dbo].[Tipo_Componente] (
    [cd_tipo_componente] INT          NOT NULL,
    [nm_tipo_componente] VARCHAR (40) NULL,
    [sg_tipo_componente] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Componente] PRIMARY KEY CLUSTERED ([cd_tipo_componente] ASC) WITH (FILLFACTOR = 90)
);

