CREATE TABLE [dbo].[Tipo_Montagem] (
    [cd_tipo_montagem] INT          NOT NULL,
    [nm_tipo_montagem] VARCHAR (60) NULL,
    [sg_tipo_montagem] CHAR (10)    NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Montagem] PRIMARY KEY CLUSTERED ([cd_tipo_montagem] ASC) WITH (FILLFACTOR = 90)
);

