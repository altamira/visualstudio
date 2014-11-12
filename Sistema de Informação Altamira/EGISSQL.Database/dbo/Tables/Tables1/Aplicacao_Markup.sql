CREATE TABLE [dbo].[Aplicacao_Markup] (
    [cd_aplicacao_markup]    INT          NOT NULL,
    [nm_aplicacao_markup]    VARCHAR (40) NOT NULL,
    [sg_aplicacao_markup]    CHAR (15)    NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_orcamento_aplicacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Aplicacao_markup] PRIMARY KEY CLUSTERED ([cd_aplicacao_markup] ASC) WITH (FILLFACTOR = 90)
);

