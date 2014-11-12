CREATE TABLE [dbo].[gond_cjtos] (
    [descricao_cjto]       NVARCHAR (50)  NULL,
    [dep_compr]            BIT            NULL,
    [dep_alt]              BIT            NULL,
    [dep_frente]           BIT            NULL,
    [dep_frontal]          BIT            NULL,
    [dep_posicao]          BIT            NULL,
    [dep_prof]             BIT            NULL,
    [ig_auto]              BIT            NULL,
    [dep_prof_outro_lado]  BIT            NULL,
    [ANGULO_INCLINACAO]    INT            NULL,
    [mensagem_nao_padrao]  NVARCHAR (200) NULL,
    [idGondCjtos]          INT            IDENTITY (1, 1) NOT NULL,
    [travar_representante] BIT            NULL
);

