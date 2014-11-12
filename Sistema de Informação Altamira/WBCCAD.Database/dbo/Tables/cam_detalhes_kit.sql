CREATE TABLE [dbo].[cam_detalhes_kit] (
    [apelido]                    NVARCHAR (20) NULL,
    [DEPENDE_ESPESSURA]          BIT           NOT NULL,
    [DEPENDE_ACABAMENTO]         BIT           NOT NULL,
    [QUANTIDADE_PAINEIS]         INT           NULL,
    [ANGULO_ENTRE_PAINEIS]       INT           NULL,
    [PAREDE_VIZINHO]             NVARCHAR (10) NULL,
    [POSICAO_PAINEL]             NVARCHAR (10) NULL,
    [ESPESSURAS_IGUAIS]          BIT           NOT NULL,
    [DEPENDE_TIPO_PAINEL]        BIT           NOT NULL,
    [QUAL_ACABAMENTO]            NVARCHAR (10) NULL,
    [QUAL_TIPO]                  NVARCHAR (10) NULL,
    [desenho]                    NVARCHAR (20) NULL,
    [somente_para_coluna]        BIT           NOT NULL,
    [somente_para_divisoria]     BIT           NOT NULL,
    [somente_alturas_diferentes] BIT           NOT NULL,
    [somente_reentrancia]        BIT           NOT NULL,
    [somente_detalhe_piso]       BIT           NOT NULL,
    [valor_adicional]            FLOAT (53)    NULL,
    [somente_quebra_frio]        BIT           NOT NULL
);

