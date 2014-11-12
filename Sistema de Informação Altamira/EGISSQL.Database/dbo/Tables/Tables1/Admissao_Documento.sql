CREATE TABLE [dbo].[Admissao_Documento] (
    [cd_documento_admissao] INT          NOT NULL,
    [nm_documento_admissao] VARCHAR (50) NULL,
    [sg_documento_admissao] CHAR (10)    NULL,
    [ds_documento_admissao] TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Admissao_Documento] PRIMARY KEY CLUSTERED ([cd_documento_admissao] ASC) WITH (FILLFACTOR = 90)
);

