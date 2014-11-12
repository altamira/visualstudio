CREATE TABLE [dbo].[Tipo_Irregularidade_Fiscal] (
    [cd_tipo_irregularid_fisca] INT          NOT NULL,
    [nm_tipo_irregularid_fisca] VARCHAR (30) NOT NULL,
    [sg_tipo_irregularid_fisca] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Irregularidade_Fiscal] PRIMARY KEY CLUSTERED ([cd_tipo_irregularid_fisca] ASC) WITH (FILLFACTOR = 90)
);

