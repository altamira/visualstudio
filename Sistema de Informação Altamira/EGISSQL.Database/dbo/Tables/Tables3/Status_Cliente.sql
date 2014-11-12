CREATE TABLE [dbo].[Status_Cliente] (
    [cd_status_cliente]              INT          NOT NULL,
    [nm_status_cliente]              VARCHAR (30) NOT NULL,
    [sg_status_cliente]              CHAR (10)    NOT NULL,
    [cd_usuario]                     INT          NOT NULL,
    [dt_usuario]                     DATETIME     NOT NULL,
    [ic_padrao_status_cliente]       CHAR (1)     NULL,
    [ic_hist_status_cliente]         CHAR (1)     NULL,
    [ic_dado_obrigatorio]            CHAR (1)     NULL,
    [ic_operacao_status_cliente]     CHAR (1)     NULL,
    [ic_permite_fechamento_proposta] CHAR (1)     NULL,
    [ic_analise_status_cliente]      CHAR (1)     NULL,
    [ic_selecao_status_cliente]      CHAR (1)     NULL,
    [ic_bloquear_edicao_cliente]     CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Cliente] PRIMARY KEY CLUSTERED ([cd_status_cliente] ASC) WITH (FILLFACTOR = 90)
);

