CREATE TABLE [dbo].[Tipo_Defeito] (
    [cd_tipo_defeito] INT          NOT NULL,
    [nm_tipo_defeito] VARCHAR (30) NULL,
    [sg_tipo_defeito] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Defeito] PRIMARY KEY CLUSTERED ([cd_tipo_defeito] ASC) WITH (FILLFACTOR = 90)
);

