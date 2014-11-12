CREATE TABLE [dbo].[Tipo_Conhecimento] (
    [cd_tipo_conhecimento]      INT          NOT NULL,
    [nm_tipo_conhecimento]      VARCHAR (30) NOT NULL,
    [sg_tipo_conhecimento]      CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_identificacao_sintegra] VARCHAR (2)  NULL,
    CONSTRAINT [PK_Tipo_Conhecimento] PRIMARY KEY CLUSTERED ([cd_tipo_conhecimento] ASC) WITH (FILLFACTOR = 90)
);

