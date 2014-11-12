CREATE TABLE [dbo].[Tipo_status_ocorrencia] (
    [cd_tipo_status_ocorrencia] INT          NOT NULL,
    [nm_tipo_status_ocorrencia] VARCHAR (40) NULL,
    [sg_tipo_status_ocorrencia] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_status_ocorrencia] PRIMARY KEY CLUSTERED ([cd_tipo_status_ocorrencia] ASC) WITH (FILLFACTOR = 90)
);

