CREATE TABLE [dbo].[Origem_Processo_Fisco_NFE] (
    [cd_origem_processo]        INT          NOT NULL,
    [nm_origem_processo]        VARCHAR (30) NULL,
    [sg_origem_processo]        CHAR (10)    NULL,
    [cd_identificacao_processo] VARCHAR (10) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_pad_origem_processo]    CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Processo_Fisco_NFE] PRIMARY KEY CLUSTERED ([cd_origem_processo] ASC)
);

