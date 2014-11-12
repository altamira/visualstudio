CREATE TABLE [dbo].[Questao_Pesquisa] (
    [cd_pesquisa]               INT           NOT NULL,
    [cd_item_questao_pesquisa]  INT           NOT NULL,
    [cd_questao_pesquisa]       INT           NOT NULL,
    [cd_ordem_questao_pesquisa] INT           NOT NULL,
    [nm_questao_pesquisa]       VARCHAR (255) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ic_ativa_questao_pesquisa] CHAR (1)      COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [qt_salto_questao_pesquisa] FLOAT (53)    NOT NULL,
    [cd_usuario]                INT           NOT NULL,
    [dt_usuario]                DATETIME      NOT NULL
);

