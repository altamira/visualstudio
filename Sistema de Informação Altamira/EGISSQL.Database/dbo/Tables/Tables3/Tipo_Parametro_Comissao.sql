CREATE TABLE [dbo].[Tipo_Parametro_Comissao] (
    [cd_tipo_parametro_comis] INT          NOT NULL,
    [nm_tipo_parametro_comis] VARCHAR (30) NOT NULL,
    [sg_tipo_parametro_comis] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Parametro_Comissao] PRIMARY KEY CLUSTERED ([cd_tipo_parametro_comis] ASC) WITH (FILLFACTOR = 90)
);

