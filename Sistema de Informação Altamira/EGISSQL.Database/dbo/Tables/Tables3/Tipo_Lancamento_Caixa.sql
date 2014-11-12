CREATE TABLE [dbo].[Tipo_Lancamento_Caixa] (
    [cd_tipo_lancamento]     INT          NOT NULL,
    [nm_tipo_lancamento]     VARCHAR (40) NULL,
    [sg_tipo_lancamento]     CHAR (10)    NULL,
    [ic_pad_tipo_lancamento] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_remessa_banco]       CHAR (1)     NULL,
    [ic_remessa_empresa]     CHAR (1)     NULL,
    [ic_motorista_caixa]     CHAR (1)     NULL,
    [ic_baixa_scr]           CHAR (1)     NULL,
    [ic_tipo_calculo]        CHAR (1)     NULL,
    [ic_livro_caixa]         CHAR (1)     NULL,
    [ic_tipo_livro_caixa]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Lancamento_Caixa] PRIMARY KEY CLUSTERED ([cd_tipo_lancamento] ASC) WITH (FILLFACTOR = 90)
);

