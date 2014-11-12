CREATE TABLE [dbo].[Ocorrencia_Tipo_Status] (
    [cd_tipo_status_ocorrencia] INT          NOT NULL,
    [nm_tipo_status_ocorrencia] VARCHAR (40) NOT NULL,
    [sg_tipo_status_ocorrencia] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Ocorrencia_Tipo_Status] PRIMARY KEY CLUSTERED ([cd_tipo_status_ocorrencia] ASC) WITH (FILLFACTOR = 90)
);

