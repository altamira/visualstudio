CREATE TABLE [dbo].[mob_aces] (
    [Descricao_principal]          NVARCHAR (50) NULL,
    [descricao_acess]              NVARCHAR (50) NULL,
    [qtde_min]                     INT           NULL,
    [qtde_max]                     INT           NULL,
    [qtde_pad]                     INT           NULL,
    [obrigatorio]                  INT           NULL,
    [consumo_eletrico]             INT           NULL,
    [desl_x]                       FLOAT (53)    NULL,
    [desl_y]                       FLOAT (53)    NULL,
    [rotacao]                      FLOAT (53)    NULL,
    [espelhar]                     BIT           NULL,
    [desl_z]                       FLOAT (53)    NULL,
    [tratar_por_chave]             BIT           NULL,
    [Cor_altera_codigo]            BIT           NULL,
    [possui_tensao]                BIT           NULL,
    [possui_frequencia]            BIT           NULL,
    [possui_parametro4]            BIT           NULL,
    [possui_parametro5]            BIT           NULL,
    [comprimento_entre_acessorios] FLOAT (53)    NULL,
    [tipo_distribuicao]            INT           NULL,
    [idMobAces]                    INT           IDENTITY (1, 1) NOT NULL
);

