CREATE TABLE [dbo].[Tipo_Variavel_Orcamento] (
    [cd_tipo_variavel_orcam] INT          NOT NULL,
    [nm_tipo_variavel_orcam] VARCHAR (40) NULL,
    [sg_tipo_variavel_orcam] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Variavel_Orcamento] PRIMARY KEY CLUSTERED ([cd_tipo_variavel_orcam] ASC) WITH (FILLFACTOR = 90)
);

