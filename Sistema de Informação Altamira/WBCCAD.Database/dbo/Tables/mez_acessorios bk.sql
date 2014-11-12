CREATE TABLE [dbo].[mez_acessorios bk] (
    [formula_dimensao]           NVARCHAR (100) NULL,
    [descricao]                  NVARCHAR (50)  NULL,
    [codigo]                     NVARCHAR (50)  NULL,
    [formula_quantidade]         NVARCHAR (100) NULL,
    [dimensao_maxima_sem_juncao] INT            NULL,
    [codigo_juncao]              NVARCHAR (50)  NULL,
    [tipo_cad]                   NVARCHAR (50)  NULL,
    [multiplo]                   INT            NULL,
    [comprimento_maximo]         INT            NULL,
    [tipo]                       NVARCHAR (255) NULL,
    [vizinho]                    BIT            NOT NULL,
    [arredondar_baixo]           BIT            NOT NULL,
    [ins_pis_metalic]            BIT            NOT NULL,
    [Aces_des_por_Pontos]        BIT            NULL
);

