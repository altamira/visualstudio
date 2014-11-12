CREATE TABLE [dbo].[Tipo_Processo_Juridico] (
    [cd_tipo_processo_juridico] INT          NOT NULL,
    [nm_tipo_processo_juridico] VARCHAR (40) NULL,
    [sg_tipo_processo_juridico] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Processo_Juridico] PRIMARY KEY CLUSTERED ([cd_tipo_processo_juridico] ASC) WITH (FILLFACTOR = 90)
);

