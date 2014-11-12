CREATE TABLE [dbo].[produtos_dimensoes_equipamentos] (
    [setor]                        NVARCHAR (50) NULL,
    [departamento]                 NVARCHAR (50) NULL,
    [utilizacao]                   NVARCHAR (50) NULL,
    [peso]                         FLOAT (53)    NULL,
    [equipamento]                  NVARCHAR (50) NULL,
    [altura]                       FLOAT (53)    NULL,
    [comprimento]                  FLOAT (53)    NULL,
    [profundidade]                 FLOAT (53)    NULL,
    [consumo_kcal]                 FLOAT (53)    NULL,
    [empilhamento_vertical_maximo] INT           NULL,
    [temperatura_exposicao]        NVARCHAR (5)  NULL,
    [desenho_cad]                  NVARCHAR (50) NULL,
    [imagem]                       NVARCHAR (50) NULL,
    [tp_desenho_sem_desenho]       INT           NULL,
    [validade_produto]             INT           NULL,
    [DESCRICAO]                    NVARCHAR (50) NULL,
    [FABRICANTE]                   NVARCHAR (50) NULL,
    [FAMILIA]                      NVARCHAR (50) NULL,
    [cor]                          NVARCHAR (5)  NULL
);

