CREATE TABLE [dbo].[Sessao_Arquivo_Magnetico] (
    [cd_documento_magnetico]     INT          NOT NULL,
    [cd_tipo_sessao]             INT          NOT NULL,
    [cd_sessao_arquivo_magneti]  INT          NOT NULL,
    [nm_sessao]                  VARCHAR (40) NULL,
    [sg_sessao]                  CHAR (10)    NULL,
    [ds_sessao]                  VARCHAR (60) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_sessao_inativa]          CHAR (1)     NULL,
    [ic_atualiza_fim]            CHAR (1)     NULL,
    [ic_detalhes]                CHAR (1)     NULL,
    [ic_filtro]                  CHAR (1)     NULL,
    [ic_verifica_tributacao_nfe] CHAR (1)     NULL,
    [cd_ordem_sessao]            INT          NULL,
    CONSTRAINT [PK_Sessao_Arquivo_Magnetico] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC, [cd_tipo_sessao] ASC, [cd_sessao_arquivo_magneti] ASC) WITH (FILLFACTOR = 90)
);

