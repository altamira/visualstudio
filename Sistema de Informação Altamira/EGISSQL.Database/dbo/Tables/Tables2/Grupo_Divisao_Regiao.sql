CREATE TABLE [dbo].[Grupo_Divisao_Regiao] (
    [cd_grupo_div_regiao]       INT          NOT NULL,
    [nm_grupo_div_regiao]       VARCHAR (30) NOT NULL,
    [sg_grupo_div_regiao]       CHAR (10)    NOT NULL,
    [cd_ordem_grupo_div_regiao] INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Divisao_Regiao] PRIMARY KEY CLUSTERED ([cd_grupo_div_regiao] ASC) WITH (FILLFACTOR = 90)
);

