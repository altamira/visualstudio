CREATE TABLE [dbo].[Divisao_Unidade_Negocio] (
    [cd_divisao_unidade]  INT          NOT NULL,
    [nm_divisao_unidade]  VARCHAR (60) NULL,
    [sg_divisao_unidade]  CHAR (10)    NULL,
    [nm_fantasia_divisao] VARCHAR (15) NULL,
    [ic_ativa_divisao]    CHAR (1)     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Divisao_Unidade_Negocio] PRIMARY KEY CLUSTERED ([cd_divisao_unidade] ASC) WITH (FILLFACTOR = 90)
);

