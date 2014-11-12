CREATE TABLE [dbo].[Tipo_Chapa] (
    [cd_tipo_chapa] INT          NOT NULL,
    [nm_tipo_chapa] VARCHAR (40) NULL,
    [sg_tipo_chapa] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Chapa] PRIMARY KEY CLUSTERED ([cd_tipo_chapa] ASC) WITH (FILLFACTOR = 90)
);

