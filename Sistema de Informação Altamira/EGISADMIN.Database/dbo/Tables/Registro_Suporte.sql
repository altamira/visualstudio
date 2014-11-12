﻿CREATE TABLE [dbo].[Registro_Suporte] (
    [cd_registro_suporte]     INT           NOT NULL,
    [dt_registro_suporte]     DATETIME      NOT NULL,
    [cd_cliente_sistema]      INT           NOT NULL,
    [cd_usuario_sistema]      INT           NOT NULL,
    [cd_prioridade_suporte]   INT           NULL,
    [cd_modulo]               INT           NOT NULL,
    [cd_versao_modulo]        VARCHAR (15)  NULL,
    [dt_ocorrencia_suporte]   DATETIME      NULL,
    [ds_ocorrencia_suporte]   TEXT          NULL,
    [ds_mensagem_suporte]     TEXT          NULL,
    [ds_observacao_suporte]   TEXT          NULL,
    [cd_menu_historico]       INT           NULL,
    [dt_solucao_registro]     DATETIME      NULL,
    [nm_solucao_registro]     VARCHAR (100) NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [nm_doc_registro_suporte] VARCHAR (100) NULL,
    [dt_solucao_dev]          DATETIME      NULL,
    [cd_nivel_suporte]        INT           NULL,
    [cd_consultor]            INT           NULL,
    [ds_solucao]              TEXT          NULL,
    [dt_retorno_cliente]      DATETIME      NULL,
    CONSTRAINT [PK_Registro_Suporte] PRIMARY KEY CLUSTERED ([cd_registro_suporte] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Suporte_Consultor_Implantacao] FOREIGN KEY ([cd_consultor]) REFERENCES [dbo].[Consultor_Implantacao] ([cd_consultor]),
    CONSTRAINT [FK_Registro_Suporte_Menu_Historico] FOREIGN KEY ([cd_menu_historico]) REFERENCES [dbo].[Menu_Historico] ([cd_menu_historico])
);

