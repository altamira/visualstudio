CREATE TABLE [dbo].[Resposta_Pesquisa] (
    [cd_pesquisa]            INT           NOT NULL,
    [cd_resposta_pesquisa]   INT           NOT NULL,
    [nm_resposta_pesquisa]   VARCHAR (100) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_resposta_pesquisa]   CHAR (10)     COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ic_ativa_resposta_pesq] CHAR (1)      COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [qt_ponto_resposta_pesq] FLOAT (53)    NOT NULL,
    [qt_pt_inicio_resp_pesq] FLOAT (53)    NOT NULL,
    [qt_pt_fim_resp_pesq]    FLOAT (53)    NOT NULL,
    [qt_saldo_resposta_pesq] FLOAT (53)    NOT NULL,
    [cd_usuario]             INT           NOT NULL,
    [dt_usuario]             DATETIME      NOT NULL
);

