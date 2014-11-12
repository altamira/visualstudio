CREATE TABLE [dbo].[Tipo_Revisao_Documento] (
    [cd_tipo_revisao_documento] INT          NOT NULL,
    [nm_tipo_revisao_documento] VARCHAR (40) NULL,
    [sg_tipo_revisao_documento] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Documento] PRIMARY KEY CLUSTERED ([cd_tipo_revisao_documento] ASC) WITH (FILLFACTOR = 90)
);

