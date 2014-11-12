CREATE TABLE [dbo].[Tipo_Apontamento] (
    [cd_tipo_apontamento] INT          NOT NULL,
    [nm_tipo_apontamento] VARCHAR (40) NULL,
    [sg_tipo_apontamento] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Apontamento] PRIMARY KEY CLUSTERED ([cd_tipo_apontamento] ASC) WITH (FILLFACTOR = 90)
);

