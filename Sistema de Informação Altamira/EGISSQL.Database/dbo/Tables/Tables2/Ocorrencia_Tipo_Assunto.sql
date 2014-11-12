CREATE TABLE [dbo].[Ocorrencia_Tipo_Assunto] (
    [cd_tipo_assunto] INT          NOT NULL,
    [nm_tipo_assunto] VARCHAR (40) NOT NULL,
    [sg_tipo_assunto] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Ocorrencia_Tipo_Assunto] PRIMARY KEY CLUSTERED ([cd_tipo_assunto] ASC) WITH (FILLFACTOR = 90)
);

