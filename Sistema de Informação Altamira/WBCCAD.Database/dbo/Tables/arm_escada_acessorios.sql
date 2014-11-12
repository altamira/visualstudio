CREATE TABLE [dbo].[arm_escada_acessorios] (
    [descricao]                  NVARCHAR (100) NULL,
    [codigo]                     NVARCHAR (50)  NULL,
    [formula_dimensao]           NVARCHAR (250) NULL,
    [formula_quantidade]         NVARCHAR (250) NULL,
    [tipo_incluir]               NVARCHAR (50)  NULL,
    [formula_comprimento]        NVARCHAR (250) NULL,
    [formula_altura]             NVARCHAR (250) NULL,
    [formula_profundidade]       NVARCHAR (250) NULL,
    [tipo_piso]                  NVARCHAR (50)  NULL,
    [tipo_cad]                   NVARCHAR (3)   NULL,
    [multiplo]                   INT            NULL,
    [dimensao_maxima_sem_juncao] INT            NULL,
    [codigo_juncao]              NVARCHAR (50)  NULL,
    [comprimento_maximo_aceitar] FLOAT (53)     NULL,
    [comprimento_minimo_aceitar] FLOAT (53)     NULL,
    [profundidade_padrao]        FLOAT (53)     NULL,
    [largura_maxima_aceitar]     FLOAT (53)     NULL,
    [largura_minima_aceitar]     FLOAT (53)     NULL,
    [acess_guarda_corpo]         BIT            NOT NULL,
    [grupo_acab]                 NVARCHAR (50)  NULL
);

