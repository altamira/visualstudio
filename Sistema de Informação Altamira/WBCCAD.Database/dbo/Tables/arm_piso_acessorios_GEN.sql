CREATE TABLE [dbo].[arm_piso_acessorios_GEN] (
    [Descricao]                  NVARCHAR (255) NULL,
    [codigo]                     NVARCHAR (255) NULL,
    [formula_quantidade]         NVARCHAR (255) NULL,
    [tipo_incluir]               NVARCHAR (255) NULL,
    [Tipo_apoio_incluir]         NVARCHAR (255) NULL,
    [formula_dimensao]           NVARCHAR (255) NULL,
    [multiplo]                   FLOAT (53)     NULL,
    [dimensao_maxima_sem_juncao] FLOAT (53)     NULL,
    [codigo_juncao]              NVARCHAR (255) NULL,
    [dimensao_padrao]            FLOAT (53)     NULL,
    [descricao_cantoneira]       NVARCHAR (255) NULL,
    [para_piso_intermediario]    BIT            NOT NULL,
    [tratar_como_piso]           BIT            NOT NULL,
    [comprimento_maximo_aceitar] FLOAT (53)     NULL,
    [comprimento_minimo_aceitar] FLOAT (53)     NULL,
    [Aces_des_por_Pontos]        BIT            NOT NULL,
    [des_retang_ref]             NVARCHAR (255) NULL,
    [cor_des_retang_ref]         NVARCHAR (255) NULL
);

