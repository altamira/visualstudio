CREATE TABLE [dbo].[Ocorrencia_Retorno_Banco] (
    [cd_banco]                  INT      NOT NULL,
    [cd_ocorrencia_retorno]     INT      NOT NULL,
    [cd_ocorrencia_retorno_ban] INT      NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [sg_ocorrencia_retorno_ban] CHAR (4) NULL
);

