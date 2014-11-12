CREATE TABLE [dbo].[Ocorrencia_Tipo_Documento] (
    [cd_tipo_documento] INT          NOT NULL,
    [nm_tipo_documento] VARCHAR (40) NOT NULL,
    [sg_tipo_documento] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    CONSTRAINT [PK_Ocorrencia_Tipo_Documento] PRIMARY KEY CLUSTERED ([cd_tipo_documento] ASC) WITH (FILLFACTOR = 90)
);

