CREATE TABLE [dbo].[arm_piso_acessorios] (
    [Descricao]                  NVARCHAR (50)  NULL,
    [codigo]                     NVARCHAR (50)  NULL,
    [formula_quantidade]         NVARCHAR (100) NULL,
    [tipo_incluir]               NVARCHAR (50)  NULL,
    [Tipo_apoio_incluir]         NVARCHAR (50)  NULL,
    [formula_dimensao]           NVARCHAR (100) NULL,
    [multiplo]                   INT            NULL,
    [dimensao_maxima_sem_juncao] INT            NULL,
    [codigo_juncao]              NVARCHAR (50)  NULL,
    [dimensao_padrao]            INT            NULL,
    [descricao_cantoneira]       NVARCHAR (10)  NULL,
    [para_piso_intermediario]    BIT            NOT NULL,
    [tratar_como_piso]           BIT            NOT NULL,
    [comprimento_maximo_aceitar] FLOAT (53)     NULL,
    [comprimento_minimo_aceitar] FLOAT (53)     NULL,
    [idArmPisoAcessorios]        INT            IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([idArmPisoAcessorios] ASC)
);

