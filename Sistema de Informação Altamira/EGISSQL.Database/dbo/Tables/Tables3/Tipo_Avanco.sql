CREATE TABLE [dbo].[Tipo_Avanco] (
    [cd_tipo_avanco] INT          NOT NULL,
    [nm_tipo_avanco] VARCHAR (40) NOT NULL,
    [sg_tipo_avanco] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Avanco] PRIMARY KEY CLUSTERED ([cd_tipo_avanco] ASC) WITH (FILLFACTOR = 90)
);

