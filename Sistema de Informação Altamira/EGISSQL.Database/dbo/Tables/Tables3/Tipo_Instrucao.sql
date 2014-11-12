CREATE TABLE [dbo].[Tipo_Instrucao] (
    [cd_tipo_instrucao] INT          NOT NULL,
    [nm_tipo_instrucao] VARCHAR (40) NULL,
    [sg_tipo_instrucao] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Instrucao] PRIMARY KEY CLUSTERED ([cd_tipo_instrucao] ASC) WITH (FILLFACTOR = 90)
);

