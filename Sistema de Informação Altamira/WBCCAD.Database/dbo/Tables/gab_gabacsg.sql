CREATE TABLE [dbo].[gab_gabacsg] (
    [corte]                  NVARCHAR (40) NULL,
    [acessorio]              NVARCHAR (40) NULL,
    [qtde_minima]            FLOAT (53)    NULL,
    [qtde_maxima]            FLOAT (53)    NULL,
    [opcional]               INT           NULL,
    [dependencia]            INT           NULL,
    [qtde_default]           FLOAT (53)    NULL,
    [altura_util]            INT           NULL,
    [potencia]               INT           NULL,
    [visivel]                BIT           NULL,
    [prioridade]             INT           NULL,
    [esconder_orcamento]     BIT           NULL,
    [Insercao]               NVARCHAR (50) NULL,
    [altura_inicial]         INT           NULL,
    [distancia_entre_niveis] INT           NULL,
    [multiplo_por_modulo]    BIT           NULL,
    [comprimento_fixo]       INT           NULL,
    [afastamento_fundo]      FLOAT (53)    NULL,
    [travar_representante]   BIT           NULL,
    [altura_fixa]            INT           NULL,
    [idGabGabacsg]           INT           IDENTITY (1, 1) NOT NULL
);

