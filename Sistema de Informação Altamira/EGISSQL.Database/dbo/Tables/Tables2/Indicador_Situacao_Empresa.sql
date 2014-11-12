CREATE TABLE [dbo].[Indicador_Situacao_Empresa] (
    [cd_indicador] INT          NOT NULL,
    [nm_indicador] VARCHAR (40) NULL,
    [sg_indicador] CHAR (10)    NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Indicador_Situacao_Empresa] PRIMARY KEY CLUSTERED ([cd_indicador] ASC)
);

