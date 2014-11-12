CREATE TABLE [dbo].[Metodo_Orcamento] (
    [cd_metodo_orcamento]        INT          NOT NULL,
    [nm_metodo_orcamento]        VARCHAR (40) NULL,
    [nm_titulo_metodo_orcamento] VARCHAR (60) NULL,
    [sg_metodo_orcamento]        CHAR (10)    NULL,
    [ic_padrao_metodo_orcamento] CHAR (1)     NULL,
    [cd_aplicacao_markup]        INT          NULL,
    [nm_obs_metodo_orcamento]    VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_classe]                  INT          NULL,
    CONSTRAINT [PK_Metodo_Orcamento] PRIMARY KEY CLUSTERED ([cd_metodo_orcamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Metodo_Orcamento_Aplicacao_Markup] FOREIGN KEY ([cd_aplicacao_markup]) REFERENCES [dbo].[Aplicacao_Markup] ([cd_aplicacao_markup])
);

